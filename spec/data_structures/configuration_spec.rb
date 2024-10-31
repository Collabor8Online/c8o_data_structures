require "rails_helper"

module DataStructures
  RSpec.describe Configuration do
    # standard:disable Lint/ConstantDefinitionInBlock
    class ConfigurationCustomTemplate
    end
    # standard:enable Lint/ConstantDefinitionInBlock
    Plumbing::Spec.modes do
      context "In #{Plumbing.config.mode} mode" do
        subject(:configuration) { described_class.start }

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

          it "pre-registers sections" do
            expect(configuration.class_for(:section).value).to eq DataStructures::Definitions::Section
          end

          it "pre-registers repeating groups" do
            expect(configuration.class_for(:repeating_group).value).to eq DataStructures::Definitions::RepeatingGroup
          end

          it "pre-registers headings" do
            expect(configuration.class_for(:heading).value).to eq DataStructures::Definitions::Heading
          end

          it "pre-registers sub-headings" do
            expect(configuration.class_for(:sub_heading).value).to eq DataStructures::Definitions::SubHeading
          end

          it "pre-registers text fields" do
            expect(configuration.class_for(:text).value).to eq DataStructures::Definitions::TextField
          end

          it "pre-registers rich text fields" do
            expect(configuration.class_for(:rich_text).value).to eq DataStructures::Definitions::RichTextField
          end

          it "pre-registers number fields" do
            expect(configuration.class_for(:number).value).to eq DataStructures::Definitions::NumberField
          end

          it "pre-registers date fields" do
            expect(configuration.class_for(:date).value).to eq DataStructures::Definitions::DateField
          end

          it "pre-registers signature fields" do
            expect(configuration.class_for(:signature).value).to eq DataStructures::Definitions::SignatureField
          end
        end

        describe "#class_for" do
          it "returns the class for the given registered name" do
            configuration.register :custom_template, "DataStructures::ConfigurationCustomTemplate"
            expect(configuration.class_for(:custom_template).value).to eq DataStructures::ConfigurationCustomTemplate
          end

          it "raises a NameError if the name is not recognised" do
            expect { configuration.class_for(:unknown).value }.to raise_error(NameError)
          end
        end
      end
    end
  end
end
