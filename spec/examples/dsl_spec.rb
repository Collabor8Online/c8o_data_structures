require "rails_helper"

RSpec.describe "DSL" do
  let(:simple_template_filename) { File.join(__dir__, "simple_template.yml") }
  let(:simple_template) { YAML.load(File.open(simple_template_filename), symbolize_names: true) }

  it "defines a simple template" do
    template = await { DataStructures["examples"].load simple_template }
    expect(template.name).to eq "Simple template"
    expect(template.description).to eq "My simple template"
    expect(template.items.size).to eq 3
  end

  let(:order_form_filename) { File.join(__dir__, "order_form.yml") }
  let(:order_form) { YAML.load(File.open(order_form_filename), symbolize_names: true) }

  it "defines a template with a repeating group" do
    template = await { DataStructures["examples"].load order_form }
    expect(template.name).to eq "Order form"
  end

  let(:fancy_order_form_filename) { File.join(__dir__, "fancy_order_form.yml") }
  let(:fancy_order_form) { YAML.load(File.open(fancy_order_form_filename), symbolize_names: true) }

  it "defines a template with sections and static content" do
    template = await { DataStructures["examples"].load fancy_order_form }
    expect(template.name).to eq "Fancy order form"
  end
end
