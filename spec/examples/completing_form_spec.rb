require "rails_helper"

RSpec.describe "Completing a form" do
  let(:fancy_order_form_filename) { File.join(__dir__, "fancy_order_form.yml") }
  let(:fancy_order_form) { YAML.load(File.open(fancy_order_form_filename)) }
  let(:template) { DataStructures::Definition.load(fancy_order_form) }
  let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
  let(:form) { Form.create(person: alice, name: "My form") }

  let(:first_section) { form.items.first }
  let(:second_section) { form.items.second }
  let(:third_section) { form.items.third }

  let(:repeating_group) { second_section.items.second }
  let(:repeat) { repeating_group.items.first }

  it "attaches items to the form based upon the contents of the template" do
    form.create_items_for template

    expect(form.items.size).to eq 3

    expect(first_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(first_section.items.size).to eq 3
    expect(first_section.items.first.definition).to be_kind_of(DataStructures::Definition::Heading)
    expect(first_section.items.second.definition).to be_kind_of(DataStructures::Definition::SubHeading)
    expect(first_section.items.third.definition).to be_kind_of(DataStructures::Definition::TextField)

    expect(second_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(second_section.items.size).to eq 2
    expect(second_section.items.first.definition).to be_kind_of(DataStructures::Definition::Heading)
    expect(second_section.items.second.definition).to be_kind_of(DataStructures::Definition::RepeatingGroup)

    expect(repeat.items.size).to eq 3
    expect(repeat.items.first.definition).to be_kind_of(DataStructures::Definition::TextField)
    expect(repeat.items.second.definition).to be_kind_of(DataStructures::Definition::NumberField)
    expect(repeat.items.third.definition).to be_kind_of(DataStructures::Definition::RichTextField)

    expect(third_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(third_section.items.size).to eq 2
    expect(third_section.items.first.definition).to be_kind_of(DataStructures::Definition::DateField)
    expect(third_section.items.second.definition).to be_kind_of(DataStructures::Definition::SignatureField)
  end

  it "stores all data for the form in a single update statement" do
    form.create_items_for template

    name_field = first_section.items.third
    item_to_order_field = repeat.items.first
    quantity_field = repeat.items.second
    reason_for_order_field = repeat.items.third
    signature_field = third_section.items.second

    form.update! items_attributes: [
      {id: first_section.id, items_attributes: [
        {id: name_field.id, value: "Alice Aardvark"}
      ]},
      {id: second_section.id, items_attributes: [
        {id: repeating_group.id, items_attributes: [
          {id: repeat.id, items_attributes: [
            {id: item_to_order_field.id, value: "Widgets"}, {id: quantity_field.id, value: "200"}, {id: reason_for_order_field.id, value: "We need widgets"}
          ]}
        ]}
      ]}, {id: third_section.id, items_attributes: [
        {id: signature_field.id, value: "FAKE SIGNATURE"}
      ]}
    ]

    expect(name_field.reload.value).to eq "Alice Aardvark"
    expect(item_to_order_field.reload.value).to eq "Widgets"
    expect(quantity_field.reload.value).to eq 200
    expect(reason_for_order_field.reload.value.to_plain_text).to eq "We need widgets"
  end

  it "adds an extra repeat to a repeating group" do
    form.create_items_for template

    repeating_group.add_group
    second_repeat = repeating_group.items.second
    repeating_group.add_group
    third_repeat = repeating_group.items.third

    name_field = first_section.items.third
    signature_field = third_section.items.second

    form.update! items_attributes: [
      {id: first_section.id, items_attributes: [
        {id: name_field.id, value: "Alice Aardvark"}
      ]},
      {id: second_section.id, items_attributes: [
        {id: repeating_group.id, items_attributes: [
          {id: repeat.id, items_attributes: [
            {id: repeat.items.first.id, value: "Widgets"}, {id: repeat.items.second.id, value: "200"}, {id: repeat.items.third.id, value: "We need widgets"}
          ]},
          {id: second_repeat.id, items_attributes: [
            {id: second_repeat.items.first.id, value: "Sprockets"}, {id: second_repeat.items.second.id, value: "10"}, {id: second_repeat.items.third.id, value: "We need sprockets"}
          ]},
          {id: third_repeat.id, items_attributes: [
            {id: third_repeat.items.first.id, value: "Grommets"}, {id: third_repeat.items.second.id, value: "99"}, {id: third_repeat.items.third.id, value: "We need grommets"}
          ]}
        ]}
      ]}, {id: third_section.id, items_attributes: [
        {id: signature_field.id, value: "FAKE SIGNATURE"}
      ]}
    ]
  end
end
