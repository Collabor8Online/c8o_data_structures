require "rails_helper"

RSpec.describe "Form" do
  let(:fancy_order_form_filename) { File.join(__dir__, "fancy_order_form.yml") }
  let(:fancy_order_form) { YAML.load(File.open(fancy_order_form_filename)) }
  let(:template) { DataStructures.load(fancy_order_form) }
  let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
  let(:form) { Form.create(person: alice, name: "My form") }

  it "attaches values to the form based upon the contents of the template" do
    form.create_values_for template

    expect(form.root_values.size).to eq 3
    first_section = form.root_values.first
    second_section = form.root_values.second
    third_section = form.root_values.third

    expect(first_section.definition).to be_kind_of(DataStructures::Definitions::Section)
    expect(first_section.values.size).to eq 3
    expect(first_section.values.first.definition).to be_kind_of(DataStructures::Definitions::Heading)
    expect(first_section.values.second.definition).to be_kind_of(DataStructures::Definitions::SubHeading)
    expect(first_section.values.third.definition).to be_kind_of(DataStructures::Definitions::TextField)

    expect(second_section.definition).to be_kind_of(DataStructures::Definitions::Section)
    expect(second_section.values.size).to eq 2
    expect(second_section.values.first.definition).to be_kind_of(DataStructures::Definitions::Heading)
    expect(second_section.values.second.definition).to be_kind_of(DataStructures::Definitions::RepeatingGroup)

    repeating_group = second_section.values.second
    expect(repeating_group.values.size).to eq 3
    expect(repeating_group.values.first.definition).to be_kind_of(DataStructures::Definitions::TextField)
    expect(repeating_group.values.second.definition).to be_kind_of(DataStructures::Definitions::NumberField)
    expect(repeating_group.values.third.definition).to be_kind_of(DataStructures::Definitions::RichTextField)

    expect(third_section.definition).to be_kind_of(DataStructures::Definitions::Section)
    expect(third_section.values.size).to eq 2
    expect(third_section.values.first.definition).to be_kind_of(DataStructures::Definitions::DateField)
    expect(third_section.values.second.definition).to be_kind_of(DataStructures::Definitions::SignatureField)
  end
end
