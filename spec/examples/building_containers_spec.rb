require "rails_helper"

RSpec.describe "Building containers" do
  let(:bob) { Person.create! first_name: "Bob", last_name: "Badger" }
  let(:form) { Form.new person: bob }

  describe "Building a form from a simple template" do
    let(:simple_template_filename) { File.join(__dir__, "simple_template.yml") }
    let(:simple_template) { YAML.load(File.open(simple_template_filename)) }

    it "builds a form with three fields" do
      template = DataStructures::Definition.load simple_template

      expect(template.name).to eq "Simple template"
      expect(template.description).to eq "My simple template"
      expect(template.items.size).to eq 3

      form.create_fields_for template
      expect(form.fields.size).to eq 3
      expect(form.fields.first.definition).to be_kind_of(DataStructures::Definition::TextField)
      expect(form.fields.second.definition).to be_kind_of(DataStructures::Definition::RichTextField)
      expect(form.fields.third.definition).to be_kind_of(DataStructures::Definition::DateField)
    end

    it "fills in the fields" do
      template = DataStructures::Definition.load simple_template

      form.create_fields_for template

      form.fields.first.update! value: "Bob"
      form.fields.second.update! value: "<p>I am Bob</p>"
      form.fields.third.update! value: Date.today
    end
  end

  describe "Building an order form" do
    let(:order_form_filename) { File.join(__dir__, "order_form.yml") }
    let(:order_form) { YAML.load(File.open(order_form_filename)) }

    it "defines a template with a repeating group" do
      template = DataStructures::Definition.load order_form
      expect(template.name).to eq "Order form"
      expect(template.items.size).to eq 4

      form.create_fields_for template
      expect(form.fields.size).to eq 4
      expect(form.fields.first.definition).to be_kind_of(DataStructures::Definition::TextField)
      expect(form.fields.second.definition).to be_kind_of(DataStructures::Definition::RepeatingGroup)
      expect(form.fields.third.definition).to be_kind_of(DataStructures::Definition::DateField)
      expect(form.fields.fourth.definition).to be_kind_of(DataStructures::Definition::SignatureField)

      repeating_group = form.fields.second
      repeat = repeating_group.fields.first
      expect(repeat.fields.size).to eq 3
      expect(repeat.fields.first.definition).to be_kind_of(DataStructures::Definition::TextField)
      expect(repeat.fields.second.definition).to be_kind_of(DataStructures::Definition::NumberField)
      expect(repeat.fields.third.definition).to be_kind_of(DataStructures::Definition::RichTextField)
    end

    it "fills in the fields" do
      template = DataStructures::Definition.load order_form

      form.create_fields_for template

      form.fields.first.update! value: "Bob"
      repeating_group = form.fields.second
      repeat = repeating_group.fields.first
      repeat.fields.first.update! value: "Widget"
      repeat.fields.second.update! value: 100
      repeat.fields.third.update! value: "We need more widgets"
      form.fields.third.update! value: Date.today
      form.fields.fourth.update! value: "FAKE SIGNATURE"
    end
  end

  describe "Building a nested order form" do
    let(:fancy_order_form_filename) { File.join(__dir__, "fancy_order_form.yml") }
    let(:fancy_order_form) { YAML.load(File.open(fancy_order_form_filename)) }

    it "defines a template with sections and static content" do
      template = DataStructures::Definition.load fancy_order_form

      expect(template.name).to eq "Fancy order form"
      expect(template.items.size).to eq 3

      form.create_fields_for template
      expect(form.fields.size).to eq 3
      expect(form.fields.first.definition).to be_kind_of(DataStructures::Definition::Section)
      expect(form.fields.second.definition).to be_kind_of(DataStructures::Definition::Section)
      expect(form.fields.third.definition).to be_kind_of(DataStructures::Definition::Section)

      header = form.fields.first
      expect(header.fields.size).to eq 3
      expect(header.fields.first.definition).to be_kind_of(DataStructures::Definition::Heading)
      expect(header.fields.second.definition).to be_kind_of(DataStructures::Definition::SubHeading)
      expect(header.fields.third.definition).to be_kind_of(DataStructures::Definition::TextField)

      order_form = form.fields.second
      expect(order_form.fields.size).to eq 2
      header = order_form.fields.first
      expect(header.definition).to be_kind_of(DataStructures::Definition::Heading)
      order_fields = order_form.fields.second
      expect(order_fields.definition).to be_kind_of(DataStructures::Definition::RepeatingGroup)
      order_item = order_fields.fields.first
      expect(order_item.fields.size).to eq 3
      expect(order_item.fields.first.definition).to be_kind_of(DataStructures::Definition::TextField)
      expect(order_item.fields.second.definition).to be_kind_of(DataStructures::Definition::NumberField)
      expect(order_item.fields.third.definition).to be_kind_of(DataStructures::Definition::RichTextField)

      footer = form.fields.third
      expect(footer.fields.size).to eq 2
      expect(footer.fields.first.definition).to be_kind_of(DataStructures::Definition::DateField)
      expect(footer.fields.second.definition).to be_kind_of(DataStructures::Definition::SignatureField)
    end
  end
end
