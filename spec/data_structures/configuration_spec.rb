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
            expect(configuration.class_for(:template).value).to eq DataStructures::Definition::Template
          end

          it "pre-registers sections" do
            expect(configuration.class_for(:section).value).to eq DataStructures::Definition::Section
          end

          it "pre-registers repeating groups" do
            expect(configuration.class_for(:repeating_group).value).to eq DataStructures::Definition::RepeatingGroup
          end

          it "pre-registers groups" do
            expect(configuration.class_for(:group).value).to eq DataStructures::Definition::Group
          end

          it "pre-registers headings" do
            expect(configuration.class_for(:heading).value).to eq DataStructures::Definition::Heading
          end

          it "pre-registers sub-headings" do
            expect(configuration.class_for(:sub_heading).value).to eq DataStructures::Definition::SubHeading
          end

          it "pre-registers text fields" do
            expect(configuration.class_for(:text).value).to eq DataStructures::Definition::TextField
          end

          it "pre-registers rich text fields" do
            expect(configuration.class_for(:rich_text).value).to eq DataStructures::Definition::RichTextField
          end

          it "pre-registers number fields" do
            expect(configuration.class_for(:number).value).to eq DataStructures::Definition::NumberField
          end

          it "pre-registers decimal fields" do
            expect(configuration.class_for(:decimal).value).to eq DataStructures::Definition::DecimalField
          end

          it "pre-registers date fields" do
            expect(configuration.class_for(:date).value).to eq DataStructures::Definition::DateField
          end

          it "pre-registers signature fields" do
            expect(configuration.class_for(:signature).value).to eq DataStructures::Definition::SignatureField
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

        describe "#type_for" do
          it "returns the type name for the given class" do
            configuration.register :custom_template, "DataStructures::ConfigurationCustomTemplate"
            expect(configuration.type_for(DataStructures::ConfigurationCustomTemplate).value).to eq "custom_template"
          end
        end
      end
    end
  end
end
