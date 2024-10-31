require "rails_helper"
require_relative "container"

module DataStructures
  RSpec.describe Template do
    describe ".new" do
      it "sets the name and description" do
        template = described_class.new name: "My template", description: "A template for testing"
        expect(template.name).to eq "My template"
        expect(template.description).to eq "A template for testing"
      end

      it_behaves_like "a container", name: "My template", description: "A template for testing"
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
  end
end
