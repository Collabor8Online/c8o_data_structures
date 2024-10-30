require "rails_helper"

module DataStructures
  RSpec.describe Configuration do
    # standard:disable Lint/ConstantDefinitionInBlock
    class ConfigurationCustomTemplate
    end
    # standard:enable Lint/ConstantDefinitionInBlock
    Plumbing::Spec.modes do
      context "In #{Plumbing.config.mode} mode" do
        subject(:configuration) { Configuration.start }

        describe "#[]" do
          it "returns the template collection with the given name" do
            fake_collection = double "DataStructures::TemplateCollection"
            configuration.set "fake collection", fake_collection

            expect(configuration["fake collection"].value).to eq fake_collection
          end

          it "creates a new template if one does not exist" do
            fake_collection = double "DataStructures::TemplateCollection"
            allow(DataStructures::TemplateCollection).to receive(:start).and_return(fake_collection)

            expect(configuration["fake collection"].value).to eq fake_collection
          end
        end

        describe "#register" do
          it "registers the given template by class name" do
            configuration.register :custom_template, "DataStructures::ConfigurationCustomTemplate"

            expect(configuration.class_for(:custom_template).value).to eq DataStructures::ConfigurationCustomTemplate
          end

          it "registers the given template by class" do
            configuration.register :custom_template, DataStructures::ConfigurationCustomTemplate

            expect(configuration.class_for(:custom_template).value).to eq DataStructures::ConfigurationCustomTemplate
          end

          it "pre-registers templates" do
            expect(configuration.class_for(:template).value).to eq DataStructures::Template
          end

          it "pre-registers sections"
          it "pre-registers repeating groups"
          it "pre-registers text fields"
        end
      end
    end
  end
end
