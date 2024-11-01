require "rails_helper"

module DataStructures
  # standard:disable Lint/ConstantDefinitionInBlock
  class LoadSpecTemplate < Definition::Template
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

      it "loads a template from a JSON string" do
        params = {"type" => "template", "name" => "My template", "description" => "Loaded from config"}.to_json

        template = definition.load(params)

        expect(template.class).to eq Definition::Template
        expect(template.name).to eq "My template"
        expect(template.description).to eq "Loaded from config"
      end

      it "requires a type to be specified" do
        expect { definition.load(name: "My template", description: "Loaded from config") }.to raise_error(ArgumentError)
      end
    end

    describe ".dump" do
      subject(:definition) { described_class }

      it "saves the template recording its type, data and items" do
        template = Definition.load type: "template", name: "My template", description: "Loaded from config", items: [
          {type: "section", items: [
            {type: "text", caption: "My text", description: "Loaded from config", required: true}
          ]}
        ]

        config = definition.dump(template)

        expect(config["type"]).to eq "template"
        expect(config["name"]).to eq "My template"
        expect(config["description"]).to eq "Loaded from config"
        expect(config["items"].size).to eq 1
        section_config = config["items"].first
        expect(section_config["type"]).to eq "section"
        expect(section_config["items"].size).to eq 1
        text_config = section_config["items"].first
        expect(text_config["type"]).to eq "text"
        expect(text_config["caption"]).to eq "My text"
        expect(text_config["description"]).to eq "Loaded from config"
        expect(text_config["required"]).to eq true
      end
    end
  end
end
