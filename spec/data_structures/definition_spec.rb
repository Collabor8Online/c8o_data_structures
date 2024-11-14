require "rails_helper"

module DataStructures
  # standard:disable Lint/ConstantDefinitionInBlock
  class LoadSpecTemplate < Definition::Template
  end
  # standard:enable Lint/ConstantDefinitionInBlock

  RSpec.describe Definition do
    let(:container) { Form.new }

    describe "#path" do
      it "is calculated from the parent path and the definition's path_name" do
        described_class.new(parent_path: "my_template", position: 1).tap do |definition|
          expect(definition.path).to eq "my_template/1"
        end
      end
    end

    describe "#reference" do
      it "is supplied when the definition is created" do
        described_class.new(reference: "my_reference").tap do |definition|
          expect(definition.reference).to eq "my_reference"
        end
      end

      it "defaults to the path" do
        described_class.new(parent_path: "my_template", position: 1).tap do |definition|
          expect(definition.reference).to eq "my_template/1"
        end
      end
    end

    describe "#to_s" do
      it "is taken from the definition's model name and position" do
        described_class.new(position: 1).tap do |definition|
          expect(definition.to_s).to eq "definition:1"
        end
      end
    end

    describe "#to_h" do
      it "is taken from the definition's attributes and type" do
        allow(DataStructures).to receive(:type_for).with(Definition).and_return("definition")
        described_class.new(parent_path: "my_template", position: 1).tap do |definition|
          expect(definition.to_h).to eq({
            "parent_path" => "my_template",
            "position" => 1,
            "reference" => "my_template/1",
            "type" => "definition"
          })
        end
      end
    end

    describe "#parent_path" do
      it "supplied by the parent" do
        described_class.new(parent_path: "my_template").tap do |definition|
          expect(definition.parent_path).to eq "my_template"
        end
      end
    end

    describe "#path_name" do
      it "defaults to the position" do
        described_class.new(position: 1).tap do |definition|
          expect(definition.path_name).to eq "1"
        end
      end
    end

    describe "#build_field" do
      subject(:definition) { described_class.new }

      it "builds a field of the given type" do
        field = definition.build_field(container: container)
        expect(field).to be_kind_of(DataStructures::Field)
        expect(field).to_not be_persisted
      end
    end

    describe ".field_class_name" do
      subject(:definition) { described_class }

      it "registers the class to be used when a field is created" do
        definition.field_class_name = "DataStructures::Group"

        actual_definition = definition.new

        expect(actual_definition.build_field(data: {some: "value"})).to be_kind_of(DataStructures::Group)
      end
    end

    describe ".load" do
      subject(:definition) { described_class }

      it "loads the template with the given type from the provided configuration" do
        DataStructures.register :load_spec_template, LoadSpecTemplate

        template = definition.load({type: "load_spec_template", name: "My template", description: "Loaded from config"})

        expect(template.class).to eq LoadSpecTemplate
        expect(template.name).to eq "My template"
        expect(template.description).to eq "Loaded from config"
        expect(template.parent_path).to be_blank
      end

      it "loads a template when using string keys" do
        params = {"type" => "template", "name" => "My template", "description" => "Loaded from config"}

        template = definition.load(params)

        expect(template.class).to eq Definition::Template
        expect(template.name).to eq "My template"
        expect(template.description).to eq "Loaded from config"
        expect(template.parent_path).to be_blank
      end

      it "loads a template from a JSON string" do
        params = {"type" => "template", "name" => "My template", "description" => "Loaded from config"}.to_json

        template = definition.load(params)

        expect(template.class).to eq Definition::Template
        expect(template.name).to eq "My template"
        expect(template.description).to eq "Loaded from config"
        expect(template.parent_path).to be_blank
      end

      it "sets the path of the created items" do
        params = {"type" => "text", "caption" => "First name"}

        field = definition.load(params, parent_path: "my_template")

        expect(field.parent_path).to eq "my_template"
        expect(field.path).to eq "my_template/first_name"
      end

      it "requires a type to be specified" do
        expect { definition.load(name: "My template", description: "Loaded from config") }.to raise_error(ArgumentError)
      end
    end

    describe ".dump" do
      subject(:definition) { described_class }

      it "saves the template recording its type, data and items" do
        template = Definition.load({type: "template", name: "My template", description: "Loaded from config", items: [
          {type: "section", items: [
            {type: "text", caption: "My text", description: "Loaded from config", required: true}
          ]}
        ]})

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
