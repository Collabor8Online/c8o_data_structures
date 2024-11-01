require "rails_helper"

module DataStructures
  RSpec.describe Value, type: :model do
    let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
    let(:container) { Form.create(person: alice, name: "My form") }

    describe "#container" do
      subject(:value) { described_class.new container: nil }

      it "must be present" do
        value.container = nil
        expect(value).to_not be_valid
        expect(value.errors).to include(:container)
      end

      it "must be a container" do
        value.container = alice
        expect(value).to_not be_valid
        expect(value.errors).to include(:container)

        value.container = container
        expect(value).to be_valid
      end
    end

    describe "#definition" do
      subject(:value) { described_class.new definition_configuration: {"type" => "text", "caption" => "What's your name?", "required" => true, "default" => "Alice"} }

      it "is loaded from the definition configuration" do
        definition = value.definition

        expect(definition).to be_kind_of(DataStructures::Definition::TextField)
        expect(definition.caption).to eq "What's your name?"
        expect(definition).to be_required
      end

      it "is written to the definition configuration" do
        value.definition = DataStructures::Definition::TextField.new(caption: "What is your favourite ice-cream?", required: true, default: "Chocolate")

        expect(value.definition_configuration["type"]).to eq "text"
        expect(value.definition_configuration["caption"]).to eq "What is your favourite ice-cream?"
        expect(value.definition_configuration["required"]).to eq true
        expect(value.definition_configuration["default"]).to eq "Chocolate"
      end
    end

    describe "#definition - nested Definition" do
      subject(:value) { described_class.create! container: container, definition: definition }
      let(:definition) { DataStructures::Definition.load("type" => "section", "items" => [{type: "heading", text: "Hello"}, {type: "sub_heading", text: "World"}, {type: "text", caption: "What is your name?"}]) }

      it "creates child values for nested Definition" do
        expect(value.values.size).to eq 3
        heading = value.values.first.definition
        expect(heading).to be_kind_of(DataStructures::Definition::Heading)
        expect(heading.text).to eq "Hello"
        sub_heading = value.values.second.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "World"
        text_field = value.values.third.definition
        expect(text_field).to be_kind_of(DataStructures::Definition::TextField)
        expect(text_field.caption).to eq "What is your name?"
      end
    end

    describe "#parent" do
      subject(:value) { described_class.create! container: container }

      it "is nil for top-level values" do
        expect(value.parent).to be_nil
      end

      it "is the parent value for nested values" do
        child = described_class.create! container: container, parent: value

        expect(child.parent).to eq value
      end
    end

    describe "#children" do
      subject(:value) { described_class.create! container: container }

      it "is empty for values without children" do
        expect(value.children).to be_empty
      end

      it "contains the child values" do
        child = described_class.create! container: container, parent: value

        expect(value.children).to include child
      end
    end

    describe "#values" do
      subject(:value) { described_class.create! container: container }
      let!(:first) { described_class.create! container: container, parent: value, position: 0 }
      let!(:second) { described_class.create! container: container, parent: value, position: 1 }

      it "returns the child values in order" do
        expect(value.values).to eq [first, second]
      end
    end

    describe "#data" do
      subject(:value) { described_class.new }

      it "is empty by default" do
        expect(value.data).to eq({})
      end

      it "can be set to a hash" do
        value.data = {name: "Alice", age: 42}

        expect(value.data).to eq("name" => "Alice", "age" => 42)
      end
    end

    describe "other data formats" do
      subject(:value) { described_class.new }

      it "can hold rich text" do
        expect(value.rich_text_value).to be_kind_of(ActionText::RichText)
      end

      it "can hold a single file attachment" do
        expect(value.attachment_value).to be_kind_of(ActiveStorage::Attached::One)
      end

      it "can hold multiple file attachments" do
        expect(value.attachment_values).to be_kind_of(ActiveStorage::Attached::Many)
      end

      it "can reference another model" do
        value.model = alice
        expect(value.model).to eq alice
      end
    end
  end
end
