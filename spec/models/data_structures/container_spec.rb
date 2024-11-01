require "rails_helper"

module DataStructures
  RSpec.describe Container, type: :model do
    subject(:container) { Form.create person: alice, name: "My form" }
    let(:alice) { Person.create first_name: "Alice", last_name: "Aardvark" }
    let!(:first_value) { Value.create container: container, position: 0 }
    let!(:second_value) { Value.create container: container, position: 1 }
    let!(:first_child_value) { Value.create container: container, parent: first_value, position: 0 }
    let!(:second_child_value) { Value.create container: container, parent: first_value, position: 1 }

    describe "#data_values" do
      it "lists all attached values" do
        [first_value, second_value, first_child_value, second_child_value].each do |value|
          expect(container.data_values).to include value
        end
      end
    end

    describe "#values" do
      it "lists attached root values in order" do
        expect(container.values.last).to eq second_value
        expect(container.values.first).to eq first_value
        expect(container.values.size).to eq 2
      end
    end

    describe "#create_values_for" do
      it "creates values, in order, for each definition in the given template" do
        template = DataStructures::Definition.load type: "template", name: "Top level items", items: [{type: "heading", text: "Hello"}, {type: "sub_heading", text: "World"}, {type: "text", caption: "What is your name?"}]

        container.create_values_for template

        expect(container.values.size).to eq 3

        heading = container.values.first.definition
        expect(heading).to be_kind_of(DataStructures::Definition::Heading)
        expect(heading.text).to eq "Hello"

        sub_heading = container.values.second.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "World"

        text_field = container.values.third.definition
        expect(text_field).to be_kind_of(DataStructures::Definition::TextField)
        expect(text_field.caption).to eq "What is your name?"
      end

      it "adds child values, in order, for each definition in the given template" do
        template = DataStructures::Definition.load type: "template", name: "Nested items", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]

        container.create_values_for template

        expect(container.values.size).to eq 1
        section = container.values.first.definition
        expect(section).to be_kind_of(DataStructures::Definition::Section)

        sub_heading = container.values.first.values.first.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.text).to eq "Hello world"
      end

      it "adds grand-child values, in order, for each definition in the given template" do
        template = DataStructures::Definition.load type: "template", name: "Nested items", items: [{type: "section", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]}]

        container.create_values_for template

        expect(container.values.size).to eq 1
        section = container.values.first
        expect(section.definition).to be_kind_of(DataStructures::Definition::Section)

        sub_section = section.values.first
        expect(sub_section.definition).to be_kind_of(DataStructures::Definition::Section)

        sub_heading = sub_section.values.first
        expect(sub_heading.definition).to be_kind_of(DataStructures::Definition::SubHeading)
        expect(sub_heading.definition.text).to eq "Hello world"
      end
    end
  end
end
