require "rails_helper"

module DataStructures
  module Definitions
    RSpec.describe TextField do
      describe ".new" do
        it "sets the caption" do
          field = described_class.new caption: "First name"
          expect(field.caption).to eq "First name"
        end

        it "sets required" do
          field = described_class.new caption: "First name", required: true
          expect(field).to be_required
        end

        it "sets the default value" do
          field = described_class.new caption: "First name", default: "John"
          expect(field.default).to eq "John"
        end

        it "sets the description" do
          field = described_class.new caption: "First name", description: "The first name"
          expect(field.description).to eq "The first name"
        end
      end

      describe "#caption" do
        it "is required" do
          expect { described_class.new caption: nil }.to raise_error(ArgumentError)
        end
      end

      describe "#description" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "First name").description).to eq ""
        end
      end

      describe "#required?" do
        it "is false by default" do
          expect(described_class.new(caption: "First name")).to_not be_required
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "First name").default).to eq ""
        end
      end
    end
  end
end
