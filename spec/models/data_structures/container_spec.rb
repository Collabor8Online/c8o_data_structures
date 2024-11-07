require "rails_helper"

module DataStructures
  RSpec.describe Container, type: :model do
    subject(:container) { Form.create person: alice, name: "My form" }
    let(:alice) { Person.create first_name: "Alice", last_name: "Aardvark" }
    let(:definition_configuration) { {"type" => "text", "caption" => "What's your name?", "required" => true, "default" => "Alice"} }
    let!(:first_field) { Field.create container: container, position: 0, definition_configuration: definition_configuration }
    let!(:second_field) { Field.create container: container, position: 1, definition_configuration: definition_configuration }
    let!(:first_child_field) { Field.create container: container, parent: first_field, position: 0, definition_configuration: definition_configuration }
    let!(:second_child_field) { Field.create container: container, parent: first_field, position: 1, definition_configuration: definition_configuration }

    describe "#data_fields" do
      it "lists all attached fields" do
        [first_field, second_field, first_child_field, second_child_field].each do |field|
          expect(container._fields).to include field
        end
      end
    end

    describe "#fields" do
      it "lists attached root fields in order" do
        expect(container.fields.last).to eq second_field
        expect(container.fields.first).to eq first_field
        expect(container.fields.size).to eq 2
      end
    end

    describe "#create_fields_for" do
      it "creates fields, in order, for each definition in the given template" do
        template = DataStructures::Definition.load({type: "template", name: "Top level fields", items: [{type: "heading", text: "Hello"}, {type: "sub_heading", text: "World"}, {type: "text", caption: "What is your name?"}]})

        container.create_fields_for template

        expect(container.fields.size).to eq 3

        heading = container.fields.first.definition
        expect(heading).to be_kind_of(DataStructures::Definition::Heading)
        expect(heading.text).to eq "Hello"

        sub_heading = container.fields.second.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "World"

        text_field = container.fields.third.definition
        expect(text_field).to be_kind_of(DataStructures::Definition::TextField)
        expect(text_field.caption).to eq "What is your name?"
      end

      it "adds child fields, in order, for each definition in the given template" do
        template = DataStructures::Definition.load({type: "template", name: "Nested fields", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]})

        container.create_fields_for template

        expect(container.fields.size).to eq 1
        section = container.fields.first.definition
        expect(section).to be_kind_of(DataStructures::Definition::Section)

        sub_heading = container.fields.first.fields.first.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "Hello world"
      end

      it "adds grand-child fields, in order, for each definition in the given template" do
        template = DataStructures::Definition.load({type: "template", name: "Nested fields", items: [{type: "section", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]}]})

        container.create_fields_for template

        expect(container.fields.size).to eq 1
        section = container.fields.first
        expect(section.definition).to be_kind_of(DataStructures::Definition::Section)

        sub_section = section.fields.first
        expect(sub_section.definition).to be_kind_of(DataStructures::Definition::Section)

        sub_heading = sub_section.fields.first
        expect(sub_heading.definition).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.definition.text).to eq "Hello world"
      end
    end
  end
end
