require "rails_helper"

module DataStructures
  RSpec.describe Container, type: :model do
    subject(:container) { Form.create person: alice, name: "My form" }
    let(:alice) { Person.create first_name: "Alice", last_name: "Aardvark" }
    let(:definition_configuration) { {"type" => "text", "caption" => "What's your name?", "required" => true, "default" => "Alice"} }
    let!(:first_item) { Item.create container: container, position: 0, definition_configuration: definition_configuration }
    let!(:second_item) { Item.create container: container, position: 1, definition_configuration: definition_configuration }
    let!(:first_child_item) { Item.create container: container, parent: first_item, position: 0, definition_configuration: definition_configuration }
    let!(:second_child_item) { Item.create container: container, parent: first_item, position: 1, definition_configuration: definition_configuration }

    describe "#data_items" do
      it "lists all attached items" do
        [first_item, second_item, first_child_item, second_child_item].each do |item|
          expect(container._items).to include item
        end
      end
    end

    describe "#items" do
      it "lists attached root items in order" do
        expect(container.items.last).to eq second_item
        expect(container.items.first).to eq first_item
        expect(container.items.size).to eq 2
      end
    end

    describe "#create_items_for" do
      it "creates items, in order, for each definition in the given template" do
        template = DataStructures::Definition.load type: "template", name: "Top level items", items: [{type: "heading", text: "Hello"}, {type: "sub_heading", text: "World"}, {type: "text", caption: "What is your name?"}]

        container.create_items_for template

        expect(container.items.size).to eq 3

        heading = container.items.first.definition
        expect(heading).to be_kind_of(DataStructures::Definition::Heading)
        expect(heading.text).to eq "Hello"

        sub_heading = container.items.second.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "World"

        text_field = container.items.third.definition
        expect(text_field).to be_kind_of(DataStructures::Definition::TextField)
        expect(text_field.caption).to eq "What is your name?"
      end

      it "adds child items, in order, for each definition in the given template" do
        template = DataStructures::Definition.load type: "template", name: "Nested items", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]

        container.create_items_for template

        expect(container.items.size).to eq 1
        section = container.items.first.definition
        expect(section).to be_kind_of(DataStructures::Definition::Section)

        sub_heading = container.items.first.items.first.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "Hello world"
      end

      it "adds grand-child items, in order, for each definition in the given template" do
        template = DataStructures::Definition.load type: "template", name: "Nested items", items: [{type: "section", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]}]

        container.create_items_for template

        expect(container.items.size).to eq 1
        section = container.items.first
        expect(section.definition).to be_kind_of(DataStructures::Definition::Section)

        sub_section = section.items.first
        expect(sub_section.definition).to be_kind_of(DataStructures::Definition::Section)

        sub_heading = sub_section.items.first
        expect(sub_heading.definition).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.definition.text).to eq "Hello world"
      end
    end
  end
end
