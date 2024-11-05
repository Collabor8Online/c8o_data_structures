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

      form.create_items_for template
      expect(form.items.size).to eq 3
      expect(form.items.first.definition).to be_kind_of(DataStructures::Definition::TextField)
      expect(form.items.second.definition).to be_kind_of(DataStructures::Definition::RichTextField)
      expect(form.items.third.definition).to be_kind_of(DataStructures::Definition::DateField)
    end

    it "fills in the fields" do
      template = DataStructures::Definition.load simple_template

      form.create_items_for template

      form.items.first.update! value: "Bob"
      form.items.second.update! value: "<p>I am Bob</p>"
      form.items.third.update! value: Date.today
    end
  end

  describe "Building an order form" do
    let(:order_form_filename) { File.join(__dir__, "order_form.yml") }
    let(:order_form) { YAML.load(File.open(order_form_filename)) }

    it "defines a template with a repeating group" do
      template = DataStructures::Definition.load order_form
      expect(template.name).to eq "Order form"
      expect(template.items.size).to eq 4

      form.create_items_for template
      expect(form.items.size).to eq 4
      expect(form.items.first.definition).to be_kind_of(DataStructures::Definition::TextField)
      expect(form.items.second.definition).to be_kind_of(DataStructures::Definition::RepeatingGroup)
      expect(form.items.third.definition).to be_kind_of(DataStructures::Definition::DateField)
      expect(form.items.fourth.definition).to be_kind_of(DataStructures::Definition::SignatureField)

      repeating_group = form.items.second
      repeat = repeating_group.items.first
      expect(repeat.items.size).to eq 3
      expect(repeat.items.first.definition).to be_kind_of(DataStructures::Definition::TextField)
      expect(repeat.items.second.definition).to be_kind_of(DataStructures::Definition::NumberField)
      expect(repeat.items.third.definition).to be_kind_of(DataStructures::Definition::RichTextField)
    end

    it "fills in the fields" do
      template = DataStructures::Definition.load order_form

      form.create_items_for template

      form.items.first.update! value: "Bob"
      repeating_group = form.items.second
      repeat = repeating_group.items.first
      repeat.items.first.update! value: "Widget"
      repeat.items.second.update! value: 100
      repeat.items.third.update! value: "We need more widgets"
      form.items.third.update! value: Date.today
      form.items.fourth.update! value: "FAKE SIGNATURE"
    end
  end

  describe "Building a nested order form" do
    let(:fancy_order_form_filename) { File.join(__dir__, "fancy_order_form.yml") }
    let(:fancy_order_form) { YAML.load(File.open(fancy_order_form_filename)) }

    it "defines a template with sections and static content" do
      template = DataStructures::Definition.load fancy_order_form

      expect(template.name).to eq "Fancy order form"
      expect(template.items.size).to eq 3

      form.create_items_for template
      expect(form.items.size).to eq 3
      expect(form.items.first.definition).to be_kind_of(DataStructures::Definition::Section)
      expect(form.items.second.definition).to be_kind_of(DataStructures::Definition::Section)
      expect(form.items.third.definition).to be_kind_of(DataStructures::Definition::Section)

      header = form.items.first
      expect(header.items.size).to eq 3
      expect(header.items.first.definition).to be_kind_of(DataStructures::Definition::Heading)
      expect(header.items.second.definition).to be_kind_of(DataStructures::Definition::SubHeading)
      expect(header.items.third.definition).to be_kind_of(DataStructures::Definition::TextField)

      order_form = form.items.second
      expect(order_form.items.size).to eq 2
      header = order_form.items.first
      expect(header.definition).to be_kind_of(DataStructures::Definition::Heading)
      order_items = order_form.items.second
      expect(order_items.definition).to be_kind_of(DataStructures::Definition::RepeatingGroup)
      order_item = order_items.items.first
      expect(order_item.items.size).to eq 3
      expect(order_item.items.first.definition).to be_kind_of(DataStructures::Definition::TextField)
      expect(order_item.items.second.definition).to be_kind_of(DataStructures::Definition::NumberField)
      expect(order_item.items.third.definition).to be_kind_of(DataStructures::Definition::RichTextField)

      footer = form.items.third
      expect(footer.items.size).to eq 2
      expect(footer.items.first.definition).to be_kind_of(DataStructures::Definition::DateField)
      expect(footer.items.second.definition).to be_kind_of(DataStructures::Definition::SignatureField)
    end
  end
end
