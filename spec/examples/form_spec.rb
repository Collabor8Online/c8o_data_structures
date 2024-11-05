require "rails_helper"

RSpec.describe "Form" do
  let(:fancy_order_form_filename) { File.join(__dir__, "fancy_order_form.yml") }
  let(:fancy_order_form) { YAML.load(File.open(fancy_order_form_filename)) }
  let(:template) { DataStructures::Definition.load(fancy_order_form) }
  let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
  let(:form) { Form.create(person: alice, name: "My form") }

  it "attaches values to the form based upon the contents of the template" do
    form.create_items_for template

    expect(form.items.size).to eq 3
    first_section = form.items.first
    second_section = form.items.second
    third_section = form.items.third

    expect(first_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(first_section.items.size).to eq 3
    expect(first_section.items.first.definition).to be_kind_of(DataStructures::Definition::Heading)
    expect(first_section.items.second.definition).to be_kind_of(DataStructures::Definition::SubHeading)
    expect(first_section.items.third.definition).to be_kind_of(DataStructures::Definition::TextField)

    expect(second_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(second_section.items.size).to eq 2
    expect(second_section.items.first.definition).to be_kind_of(DataStructures::Definition::Heading)
    expect(second_section.items.second.definition).to be_kind_of(DataStructures::Definition::RepeatingGroup)

    repeating_group = second_section.items.second
    repeat = repeating_group.items.first
    expect(repeat.items.size).to eq 3
    expect(repeat.items.first.definition).to be_kind_of(DataStructures::Definition::TextField)
    expect(repeat.items.second.definition).to be_kind_of(DataStructures::Definition::NumberField)
    expect(repeat.items.third.definition).to be_kind_of(DataStructures::Definition::RichTextField)

    expect(third_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(third_section.items.size).to eq 2
    expect(third_section.items.first.definition).to be_kind_of(DataStructures::Definition::DateField)
    expect(third_section.items.second.definition).to be_kind_of(DataStructures::Definition::SignatureField)
  end
end
