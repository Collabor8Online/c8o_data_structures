require "rails_helper"

module DataStructures
  RSpec.describe Item, type: :model do
    let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
    let(:container) { Form.create(person: alice, name: "My form") }
    let(:definition_configuration) { {"type" => "text", "caption" => "What's your name?", "required" => true, "default" => "Alice"} }

    describe "#container" do
      subject(:item) { described_class.new container: nil }

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
      subject(:item) { described_class.new definition_configuration: definition_configuration }

      it "is loaded from the definition configuration" do
        definition = item.definition

        expect(definition).to be_kind_of(DataStructures::Definition::TextField)
        expect(definition.caption).to eq "What's your name?"
        expect(definition).to be_required
      end

      it "is written to the definition configuration" do
        item.definition = DataStructures::Definition::TextField.new(caption: "What is your favourite ice-cream?", required: true, default: "Chocolate")

        expect(item.definition_configuration["type"]).to eq "text"
        expect(item.definition_configuration["caption"]).to eq "What is your favourite ice-cream?"
        expect(item.definition_configuration["required"]).to eq true
        expect(item.definition_configuration["default"]).to eq "Chocolate"
      end
    end

    describe "#definition - nested Definition" do
      subject(:item) { described_class.create! container: container, definition: definition }
      let(:definition) { DataStructures::Definition.load("type" => "section", "items" => [{type: "heading", text: "Hello"}, {type: "sub_heading", text: "World"}, {type: "text", caption: "What is your name?"}]) }

      it "creates child items for nested Definition" do
        expect(item.items.size).to eq 3
        heading = item.items.first.definition
        expect(heading).to be_kind_of(DataStructures::Definition::Heading)
        expect(heading.text).to eq "Hello"
        sub_heading = item.items.second.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "World"
        text_field = item.items.third.definition
        expect(text_field).to be_kind_of(DataStructures::Definition::TextField)
        expect(text_field.caption).to eq "What is your name?"
      end
    end

    describe "#parent" do
      subject(:item) { described_class.create! container: container }

      it "is nil for top-level items" do
        expect(item.parent).to be_nil
      end

      it "is the parent item for nested items" do
        child = described_class.create! container: container, parent: item

        expect(child.parent).to eq item
      end
    end

    describe "#children" do
      subject(:item) { described_class.create! container: container }

      it "is empty for items without children" do
        expect(item.children).to be_empty
      end

      it "contains the child items" do
        child = described_class.create! container: container, parent: item

        expect(item.children).to include child
      end
    end

    describe "#items" do
      subject(:item) { described_class.create! container: container, definition_configuration: definition_configuration }
      let!(:first) { described_class.create! container: container, parent: item, position: 0 }
      let!(:second) { described_class.create! container: container, parent: item, position: 1 }

      it "returns the child items in order" do
        expect(item.items).to eq [first, second]
      end
    end

    describe "#data" do
      subject(:item) { described_class.new }

      it "is empty by default" do
        expect(item.data).to eq({})
      end

      it "can be set to a hash" do
        item.data = {name: "Alice", age: 42}

        expect(item.data).to eq("name" => "Alice", "age" => 42)
      end
    end

    describe "other data formats" do
      subject(:item) { described_class.new }

      it "can hold rich text" do
        expect(item.rich_text_value).to be_kind_of(ActionText::RichText)
      end

      it "can hold a single file attachment" do
        expect(item.attachment_value).to be_kind_of(ActiveStorage::Attached::One)
      end

      it "can hold multiple file attachments" do
        expect(item.attachment_values).to be_kind_of(ActiveStorage::Attached::Many)
      end

      it "can reference another model" do
        item.model = alice
        expect(item.model).to eq alice
      end
    end
  end
end
