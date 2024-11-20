require "rails_helper"
require_relative "collection_of_definitions"

module DataStructures
  class Definition
    RSpec.describe Template do
      it_behaves_like "a collection of definitions", name: "My template", description: "A template for testing"

      describe ".new" do
        it "sets the name and description" do
          template = described_class.new name: "My template", description: "A template for testing"
          expect(template.name).to eq "My template"
          expect(template.description).to eq "A template for testing"
        end
      end

      describe "#name" do
        it "is required" do
          expect(described_class.new(name: nil, description: "A template for testing")).to_not be_valid
        end
      end

      describe "#description" do
        it "defaults to an empty string" do
          expect(described_class.new(name: "My template").description).to eq ""
        end
      end

      describe "#path_name" do
        it "is blank" do
          expect(described_class.new(name: "My template").path_name).to be_blank
        end
      end
    end
  end
end
