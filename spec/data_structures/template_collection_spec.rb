require "rails_helper"

module DataStructures
  RSpec.describe TemplateCollection do
    # standard:disable Lint/ConstantDefinitionInBlock
    class LoadSpecTemplate < Struct.new(:name, :description, keyword_init: true)
    end
    # standard:enable Lint/ConstantDefinitionInBlock

    Plumbing::Spec.modes do
      context "In #{Plumbing.config.mode} mode" do
        let(:configuration) { Configuration.start }
        subject(:collection) { TemplateCollection.start configuration }

        describe "#[]" do
          it "returns the template with the given name" do
            template = double("template")
            collection.set "Fake template", template

            expect { collection["Fake template"].value }.to become template
          end
        end

        describe "#load" do
          it "creates and registers the template with the given class" do
            configuration.register :load_spec_template, LoadSpecTemplate

            template = await { collection.load(type: :load_spec_template, name: "My template", description: "Loaded from config") }

            expect(template.class).to eq LoadSpecTemplate
            expect(template.name).to eq "My template"
            expect(template.description).to eq "Loaded from config"
            expect { collection["My template"].value }.to become template
          end

          it "creates and registers a standard template if no type is supplied" do
            template = await { collection.load(name: "My template", description: "Loaded from config") }

            expect(template.class).to eq DataStructures::Template
            expect(template.name).to eq "My template"
            expect(template.description).to eq "Loaded from config"
            expect { collection["My template"].value }.to become template
          end
        end
      end
    end
  end
end
