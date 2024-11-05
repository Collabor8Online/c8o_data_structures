require "rails_helper"

RSpec.describe "Completing a form" do
  let(:fancy_order_form_filename) { File.join(__dir__, "fancy_order_form.yml") }
  let(:fancy_order_form) { YAML.load(File.open(fancy_order_form_filename)) }
  let(:template) { DataStructures::Definition.load(fancy_order_form) }
  let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
  let(:form) { Form.create(person: alice, name: "My form") }

  let(:first_section) { form.fields.first }
  let(:second_section) { form.fields.second }
  let(:third_section) { form.fields.third }

  let(:repeating_group) { second_section.fields.second }
  let(:group) { repeating_group.groups.first }

  it "attaches items to the form based upon the contents of the template" do
    form.create_fields_for template

    expect(form.fields.size).to eq 3

    expect(first_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(first_section.fields.size).to eq 3
    expect(first_section.fields.first.definition).to be_kind_of(DataStructures::Definition::Heading)
    expect(first_section.fields.second.definition).to be_kind_of(DataStructures::Definition::SubHeading)
    expect(first_section.fields.third.definition).to be_kind_of(DataStructures::Definition::TextField)

    expect(second_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(second_section.fields.size).to eq 2
    expect(second_section.fields.first.definition).to be_kind_of(DataStructures::Definition::Heading)
    expect(second_section.fields.second.definition).to be_kind_of(DataStructures::Definition::RepeatingGroup)

    expect(group.fields.size).to eq 3
    expect(group.fields.first.definition).to be_kind_of(DataStructures::Definition::TextField)
    expect(group.fields.second.definition).to be_kind_of(DataStructures::Definition::NumberField)
    expect(group.fields.third.definition).to be_kind_of(DataStructures::Definition::RichTextField)

    expect(third_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(third_section.fields.size).to eq 2
    expect(third_section.fields.first.definition).to be_kind_of(DataStructures::Definition::DateField)
    expect(third_section.fields.second.definition).to be_kind_of(DataStructures::Definition::SignatureField)
  end

  it "stores all data for the form in a single update statement" do
    form.create_fields_for template

    name_field = first_section.fields.third
    item_to_order_field = group.fields.first
    quantity_field = group.fields.second
    reason_for_order_field = group.fields.third
    signature_field = third_section.fields.second

    form.update! fields_attributes: {
      "0" => {id: first_section.id, fields_attributes: {
        "0" => {id: name_field.id, value: "Alice Aardvark"}
      }},
      "1" => {id: second_section.id, fields_attributes: {
        "0" => {id: repeating_group.id, fields_attributes: {
          "0" => {id: group.id, fields_attributes: {
            "0" => {id: item_to_order_field.id, value: "Widgets"},
            "1" => {id: quantity_field.id, value: "200"},
            "2" => {id: reason_for_order_field.id, value: "We need widgets"}
          }}
        }}
      }},
      "2" => {id: third_section.id, fields_attributes: {
        "0" => {id: signature_field.id, value: "FAKE SIGNATURE"}
      }}
    }

    expect(name_field.reload.value).to eq "Alice Aardvark"
    expect(item_to_order_field.reload.value).to eq "Widgets"
    expect(quantity_field.reload.value).to eq 200
    expect(reason_for_order_field.reload.value.to_plain_text).to eq "We need widgets"
  end

  it "adds an extra group to a repeating group" do
    form.create_fields_for template

    repeating_group.add_group
    second_group = repeating_group.groups.second
    repeating_group.add_group
    third_group = repeating_group.groups.third

    name_field = first_section.fields.third
    signature_field = third_section.fields.second

    form.update! fields_attributes: {
      "0" => {id: first_section.id, fields_attributes: {
        "0" => {id: name_field.id, value: "Alice Aardvark"}
      }},
      "1" => {id: second_section.id, fields_attributes: {
        "0" => {id: repeating_group.id, fields_attributes: {
          "0" => {id: group.id, fields_attributes: {
            "0" => {id: group.fields.first.id, value: "Widgets"},
            "1" => {id: group.fields.second.id, value: "200"},
            "2" => {id: group.fields.third.id, value: "We need widgets"}
          }},
          "1" => {id: second_group.id, fields_attributes: {
            "0" => {id: second_group.fields.first.id, value: "Sprockets"},
            "1" => {id: second_group.fields.second.id, value: "10"},
            "2" => {id: second_group.fields.third.id, value: "We need sprockets"}
          }},
          "2" => {id: third_group.id, fields_attributes: {
            "0" => {id: third_group.fields.first.id, value: "Grommets"},
            "1" => {id: third_group.fields.second.id, value: "99"},
            "2" => {id: third_group.fields.third.id, value: "We need grommets"}
          }}
        }}
      }},
      "2" => {id: third_section.id, fields_attributes: {
        "0" => {id: signature_field.id, value: "FAKE SIGNATURE"}
      }}
    }
  end
end
