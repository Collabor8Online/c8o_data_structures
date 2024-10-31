require "rails_helper"

module DataStructures
  RSpec.describe Container, type: :model do
    subject(:container) { Form.create person: alice, name: "My form" }
    let(:alice) { Person.create first_name: "Alice", last_name: "Aardvark" }
    let!(:first_value) { Value.create container: container, position: 0 }
    let!(:second_value) { Value.create container: container, position: 1 }
    let!(:first_child_value) { Value.create container: container, parent: first_value, position: 0 }
    let!(:second_child_value) { Value.create container: container, parent: first_value, position: 1 }

    describe "#values" do
      it "lists attached values" do
        [first_value, second_value, first_child_value, second_child_value].each do |value|
          expect(container.values).to include value
        end
      end
    end

    describe "#root_values" do
      it "lists attached root values in order" do
        expect(container.root_values.last).to eq second_value
        expect(container.root_values.first).to eq first_value
        expect(container.root_values.size).to eq 2
      end
    end

    describe "#create_values_for" do
      it "creates values, in order, for each definition in the given template" do
        template = DataStructures.load type: "template", name: "Top level items", items: [{type: "heading", text: "Hello"}, {type: "sub_heading", text: "World"}, {type: "text", caption: "What is your name?"}]

        container.create_values_for template

        expect(container.root_values.size).to eq 3

        heading = container.root_values.first.definition
        expect(heading).to be_kind_of(DataStructures::Definitions::Heading)
        expect(heading.text).to eq "Hello"

        sub_heading = container.root_values.second.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definitions::SubHeading)
        expect(sub_heading.text).to eq "World"

        text_field = container.root_values.third.definition
        expect(text_field).to be_kind_of(DataStructures::Definitions::TextField)
        expect(text_field.caption).to eq "What is your name?"
      end

      it "adds child values, in order, for each definition in the given template" do
        template = DataStructures.load type: "template", name: "Nested items", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]

        container.create_values_for template

        puts container.root_values.map { |v| v.definition.class.name }.inspect
        expect(container.root_values.size).to eq 1
        section = container.root_values.first.definition
        expect(section).to be_kind_of(DataStructures::Definitions::Section)

        sub_heading = container.root_values.first.values.first.definition
        expect(sub_heading).to be_kind_of(DataStructures::Definitions::SubHeading)
        expect(sub_heading.text).to eq "Hello world"
      end

      it "adds grand-child values, in order, for each definition in the given template" do
        template = DataStructures.load type: "template", name: "Nested items", items: [{type: "section", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]}]

        container.create_values_for template

        expect(container.root_values.size).to eq 1
        section = container.root_values.first
        expect(section.definition).to be_kind_of(DataStructures::Definitions::Section)

        sub_section = section.values.first
        expect(sub_section.definition).to be_kind_of(DataStructures::Definitions::Section)

        sub_heading = sub_section.values.first
        expect(sub_heading.definition).to be_kind_of(DataStructures::Definitions::SubHeading)
        expect(sub_heading.definition.text).to eq "Hello world"
      end
    end
  end
end
