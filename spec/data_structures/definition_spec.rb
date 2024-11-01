require "rails_helper"

module DataStructures
  # standard:disable Lint/ConstantDefinitionInBlock
  class LoadSpecTemplate < Struct.new(:name, :description, keyword_init: true)
  end
  # standard:enable Lint/ConstantDefinitionInBlock

  RSpec.describe Definition do
    describe ".load" do
      subject(:definition) { described_class }

      it "loads the template with the given type from the provided configuration" do
        DataStructures.register :load_spec_template, LoadSpecTemplate

        template = definition.load(type: :load_spec_template, name: "My template", description: "Loaded from config")

        expect(template.class).to eq LoadSpecTemplate
        expect(template.name).to eq "My template"
        expect(template.description).to eq "Loaded from config"
      end

      it "loads a template when using string keys" do
        params = {"type" => "template", "name" => "My template", "description" => "Loaded from config"}

        template = definition.load(params)

        expect(template.class).to eq Definition::Template
        expect(template.name).to eq "My template"
        expect(template.description).to eq "Loaded from config"
      end

      it "requires a type to be specified" do
        expect { definition.load(name: "My template", description: "Loaded from config") }.to raise_error(ArgumentError)
      end
    end
  end
end
