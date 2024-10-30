require "rails_helper"

module DataStructures
  RSpec.describe TemplateCollection do
    Plumbing::Spec.modes do
      context "In #{Plumbing.config.mode} mode" do
        let(:configuration) { Configuration.start }
        subject(:collection) { described_class.start configuration }

        describe "#[]" do
          it "returns the template with the given name" do
            template = double("template")
            collection.set "Fake template", template

            expect { collection["Fake template"].value }.to become template
          end
        end

        describe "#load" do
          it "creates and registers the template with the given class" do
            template = double("template", name: "My template")

            allow(DataStructures).to receive(:load).with({type: :template, name: "My template", description: "Loaded from config"}).and_return(template)

            result = await { collection.load(type: :template, name: "My template", description: "Loaded from config") }
            expect(result).to eq template
            expect { collection["My template"].value }.to become template
          end
        end
      end
    end
  end
end
