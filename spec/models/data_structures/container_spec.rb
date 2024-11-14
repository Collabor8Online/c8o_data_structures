require "rails_helper"

module DataStructures
  RSpec.describe Container, type: :model do
    subject(:container) { Form.create person: alice, name: "My form" }
    let(:alice) { Person.create first_name: "Alice", last_name: "Aardvark" }

    describe "#fields" do
      subject(:container) { Form.create person: alice, name: "My form" }
      let(:template) { DataStructures::Definition.load({"type" => "template", "name" => "My form", "items" => [{"type" => "text", "reference" => "first_name", "caption" => "First name"}, {"type" => "text", "reference" => "last_name", "caption" => "Last name"}]}) }

      it "lists attached root fields in order" do
        container.create_fields_for template

        expect(container.fields.size).to eq 2
        expect(container.fields.first.definition.caption).to eq "First name"
        expect(container.fields.second.definition.caption).to eq "Last name"
      end
    end

    describe "#create_fields_for" do
      context "when there are no existing fields stored on the container" do
        it "creates fields, in order, for each definition in the given template" do
          template = DataStructures::Definition.load({type: "template", name: "Top level fields", items: [{type: "heading", text: "Hello", reference: "hello"}, {type: "sub_heading", text: "World", reference: "world"}, {type: "text", caption: "What is your name?", reference: "name"}]})
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
          template = DataStructures::Definition.load({type: "template", name: "Very nested fields", items: [{type: "section", items: [{type: "section", items: [{type: "sub_heading", text: "Hello world"}]}]}]})

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

      context "when there are existing fields stored on the container" do
        it "matches existing fields by their field name and the definition's reference" do
          template = DataStructures::Definition.load({type: "template", name: "Nested fields", items: [{type: "section", reference: "first_section", items: [{type: "section", reference: "sub_section", items: [{type: "sub_heading", reference: "sub_heading", text: "Hello world"}, {type: "text", reference: "first_name", caption: "First name"}, {type: "text", reference: "last_name", caption: "Last name"}]}]}]})

          container.create_fields_for template
          sub_heading_field = container.field "first_section/sub_section/sub_heading"
          first_name_field = container.field "first_section/sub_section/first_name"
          last_name_field = container.field "first_section/sub_section/last_name"

          # Update the definition - swap first name and last name fields, and make last name a mandatory field
          reordered_template = DataStructures::Definition.load({type: "template", name: "Nested fields", items: [{type: "section", reference: "first_section", items: [{type: "section", reference: "sub_section", items: [{type: "sub_heading", text: "Here are some questions"}, {type: "text", reference: "last_name", caption: "Last name", required: true}, {type: "text", reference: "first_name", caption: "First name"}]}]}]})

          container.create_fields_for reordered_template

          new_sub_heading_field = container.field "first_section/sub_section/sub_heading"
          expect(new_sub_heading_field.id).to eq sub_heading_field.id
          expect(new_sub_heading_field.definition).to be_kind_of(DataStructures::Definition::SubHeading)

          new_first_name_field = container.field "first_section/sub_section/first_name"
          expect(new_first_name_field.id).to eq first_name_field.id
          expect(new_first_name_field.caption).to eq "First name"
          expect(new_first_name_field.position).to eq 3
          expect(new_first_name_field).to_not be_required

          new_last_name_field = container.field "first_section/sub_section/last_name"
          expect(new_last_name_field.id).to eq last_name_field.id
          expect(new_last_name_field.caption).to eq "Last name"
          expect(new_last_name_field.position).to eq 2
          expect(new_last_name_field).to be_required
        end
      end
    end

    describe "#find_field" do
      it "finds fields by field_name" do
        template = DataStructures::Definition.load({type: "template", name: "Nested fields", items: [{type: "section", reference: "top_section", items: [{type: "section", reference: "middle_section", items: [{type: "sub_heading", reference: "sub_heading", text: "Hello world"}, {type: "text", reference: "first_name", caption: "First name"}, {type: "text", reference: "last_name", caption: "Last name"}]}]}]})

        container.create_fields_for template

        sub_heading = container.field "top_section/middle_section/sub_heading"
        expect(sub_heading.definition).to be_kind_of DataStructures::Definition::SubHeading

        first_name = container.field "top_section/middle_section/first_name"
        expect(first_name.definition).to be_kind_of DataStructures::Definition::TextField
        expect(first_name.caption).to eq "First name"

        last_name = container.field "top_section/middle_section/last_name"
        expect(last_name.definition).to be_kind_of DataStructures::Definition::TextField
        expect(last_name.caption).to eq "Last name"
      end
    end
  end
end
