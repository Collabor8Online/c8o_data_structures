require "rails_helper"

RSpec.describe "Form" do
  let(:fancy_order_form_filename) { File.join(__dir__, "fancy_order_form.yml") }
  let(:fancy_order_form) { YAML.load(File.open(fancy_order_form_filename)) }
  let(:template) { DataStructures.load(fancy_order_form) }
  let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
  let(:form) { Form.create(person: alice, name: "My form") }

  it "attaches values to the form based upon the contents of the template" do
    form.create_values_for template

    expect(form.values.size).to eq 3
    first_section = form.values.first
    second_section = form.values.second
    third_section = form.values.third

    expect(first_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(first_section.values.size).to eq 3
    expect(first_section.values.first.definition).to be_kind_of(DataStructures::Definition::Heading)
    expect(first_section.values.second.definition).to be_kind_of(DataStructures::Definition::SubHeading)
    expect(first_section.values.third.definition).to be_kind_of(DataStructures::Definition::TextField)

    expect(second_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(second_section.values.size).to eq 2
    expect(second_section.values.first.definition).to be_kind_of(DataStructures::Definition::Heading)
    expect(second_section.values.second.definition).to be_kind_of(DataStructures::Definition::RepeatingGroup)

    repeating_group = second_section.values.second
    expect(repeating_group.values.size).to eq 3
    expect(repeating_group.values.first.definition).to be_kind_of(DataStructures::Definition::TextField)
    expect(repeating_group.values.second.definition).to be_kind_of(DataStructures::Definition::NumberField)
    expect(repeating_group.values.third.definition).to be_kind_of(DataStructures::Definition::RichTextField)

    expect(third_section.definition).to be_kind_of(DataStructures::Definition::Section)
    expect(third_section.values.size).to eq 2
    expect(third_section.values.first.definition).to be_kind_of(DataStructures::Definition::DateField)
    expect(third_section.values.second.definition).to be_kind_of(DataStructures::Definition::SignatureField)
  end
end
