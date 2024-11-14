require "rails_helper"

module DataStructures
  RSpec.describe Field, type: :model do
    let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
    let(:container) { Form.create(person: alice, name: "My form") }
    let(:what_is_your_name) { DataStructures::Definition.load({type: "text", reference: "name", caption: "What's your name?", required: true, default: "Alice"}) }

    describe "#container" do
      subject(:item) { described_class.new container: nil, definition: what_is_your_name }

      it "must be present" do
        item.container = nil
        expect(item).to_not be_valid
        expect(item.errors).to include(:container)
      end

      it "must be a container" do
        item.container = alice
        expect(item).to_not be_valid
        expect(item.errors).to include(:container)

        item.container = container
        expect(item).to be_valid
      end
    end

    describe "#definition" do
      subject(:item) { described_class.create! container: container, definition_configuration: {type: "text", reference: "the_question", caption: "What is your name?", required: true} }

      it "is loaded from the definition configuration" do
        definition = item.definition

        expect(definition).to be_kind_of(DataStructures::Definition::TextField)
        expect(definition.caption).to eq "What is your name?"
        expect(definition).to be_required
      end

      it "is written to the definition configuration" do
        item.definition = DataStructures::Definition::TextField.new(caption: "What is your favourite ice cream?", required: true, default: "Chocolate")

        expect(item.definition_configuration["type"]).to eq "text"
        expect(item.definition_configuration["caption"]).to eq "What is your favourite ice cream?"
        expect(item.definition_configuration["required"]).to eq true
        expect(item.definition_configuration["default"]).to eq "Chocolate"
      end

      it "takes its field_name from the definition's reference" do
        expect(item.field_name).to eq "the_question"
      end

      it "updates the field_name when the definition is updated" do
        item.update! definition: DataStructures::Definition::TextField.new(caption: "What is your favourite ice cream?", reference: "ice_cream", required: true, default: "Chocolate")

        expect(item.field_name).to eq "ice_cream"
      end

      it "updates the field_name when the definition configuration is updated" do
        item.update! definition_configuration: {type: "text", reference: "ice_cream", caption: "What is your favourite ice cream?", required: true, default: "Chocolate"}

        expect(item.field_name).to eq "ice_cream"
      end
    end

    describe "#definition - nested Definition" do
      subject(:section) { described_class.create! container: container, definition: definition }
      let(:definition) { DataStructures::Definition.load({type: "section", reference: "the_section", items: [{type: "heading", reference: "hello", text: "Hello"}, {type: "sub_heading", reference: "world", text: "World"}, {type: "text", reference: "name", caption: "What is your name?"}]}) }

      it "creates child fields for a nested definition" do
        expect(section.fields.size).to eq 3

        heading = section.fields.first.definition
        expect(heading).to be_kind_of(DataStructures::Definition::Heading)
        expect(heading.text).to eq "Hello"

        sub_heading = section.fields.second.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "World"

        text_field = section.fields.third.definition
        expect(text_field).to be_kind_of(DataStructures::Definition::TextField)
        expect(text_field.caption).to eq "What is your name?"
      end

      it "sets the field names for the nested fields based upon the parent field and the definition's reference" do
        expect(section.field_name).to eq "the_section"

        heading = section.fields.first
        expect(heading.field_name).to eq "the_section/hello"

        sub_heading = section.fields.second
        expect(sub_heading.field_name).to eq "the_section/world"

        text_field = section.fields.third
        expect(text_field.field_name).to eq "the_section/name"
      end
    end

    describe "#parent" do
      subject(:item) { described_class.create! container: container, definition_configuration: {type: "section"} }

      it "is nil for top-level items" do
        expect(item.parent).to be_nil
      end

      it "is the parent item for nested items" do
        child = described_class.create! container: container, parent: item, definition: what_is_your_name

        expect(child.parent).to eq item
      end
    end

    describe "#children" do
      subject(:item) { described_class.create! container: container, definition_configuration: {type: "section"} }

      it "is empty for items without children" do
        expect(item.children).to be_empty
      end

      it "contains the child items" do
        child = described_class.create! container: container, parent: item, definition: what_is_your_name

        expect(item.children).to include child
      end
    end

    describe "#fields" do
      subject(:section) { described_class.create! container: container, definition_configuration: {type: "section"} }
      let!(:first) { described_class.create! container: container, parent: section, position: 0, definition_configuration: {type: "text", caption: "First question"} }
      let!(:second) { described_class.create! container: container, parent: section, position: 1, definition_configuration: {type: "text", caption: "Second question"} }
      let!(:second_section) { described_class.create! container: container, parent: section, position: 2, definition_configuration: {type: "section"} }

      it "returns the child fields in order" do
        expect(section.fields).to eq [first, second, second_section]
      end

      it "does not return nested fields" do
        nested = described_class.create! container: container, parent: second_section, position: 0, definition_configuration: {type: "text", caption: "Nested underneath the section section"}

        expect(section.fields).to_not include nested
      end
    end

    describe "#field and #find_all_fields" do
      subject(:section) { described_class.create! container: container, definition_configuration: {type: "section"} }
      let!(:first_field) { described_class.create! container: container, parent: section, position: 1, definition_configuration: {type: "text", reference: "the_field", caption: "First question"} }
      let!(:second_section) { described_class.create! container: container, parent: section, position: 2, definition_configuration: {type: "section"} }
      let!(:second_field) { described_class.create! container: container, parent: second_section, position: 1, definition_configuration: {type: "text", reference: "the_field", caption: "Second question"} }

      it "finds a field with the given reference as a direct child of this field" do
        field = section.field "the_field"

        expect(field).to eq first_field
      end

      it "finds all fields with the given reference as descendants of this field" do
        fields = section.find_all_fields "the_field"

        expect(fields).to eq [first_field, second_field]
      end
    end

    describe "#caption" do
      context "when the definition is a field" do
        subject(:field) { described_class.create! container: container, definition: what_is_your_name }

        it "returns the caption from the definition" do
          expect(field.caption).to eq "What's your name?"
        end
      end

      context "when the definition is a collection" do
        subject(:field) { described_class.create! container: container, definition_configuration: {type: "section"} }

        it "returns a blank caption" do
          expect(field.caption).to be_blank
        end
      end
    end

    describe "#required?" do
      context "when the definition is a field" do
        subject(:field) { described_class.create! container: container, definition: what_is_your_name }

        it "returns the required value from the definition" do
          expect(field).to be_required
        end
      end

      context "when the definition is a collection" do
        subject(:field) { described_class.create! container: container, definition_configuration: {type: "section"} }

        it "returns false" do
          expect(field).to_not be_required
        end
      end
    end

    describe "#field_name" do
      subject(:field) { described_class.create! container: container, definition: what_is_your_name }

      it "returns the field_name from the definition" do
        expect(field.field_name).to eq "name"
      end

      it "is unique within the container" do
        expect(field).to be_valid

        duplicate = described_class.create container: container, definition: what_is_your_name

        expect(duplicate).to_not be_valid
        expect(duplicate.errors).to include(:field_name)
      end
    end

    describe "#data" do
      subject(:field) { described_class.new }

      it "is empty by default" do
        expect(field.data).to eq({})
      end

      it "can be set to a hash" do
        field.data = {name: "Alice", age: 42}

        expect(field.data).to eq("name" => "Alice", "age" => 42)
      end
    end

    describe "other data formats" do
      subject(:field) { described_class.new }

      it "can hold rich text" do
        expect(field.rich_text_value).to be_kind_of(ActionText::RichText)
      end

      it "can hold a single file attachment" do
        expect(field.attachment_value).to be_kind_of(ActiveStorage::Attached::One)
      end

      it "can hold multiple file attachments" do
        expect(field.attachment_values).to be_kind_of(ActiveStorage::Attached::Many)
      end

      it "can reference another model" do
        field.model = alice
        expect(field.model).to eq alice
      end
    end
  end
end
