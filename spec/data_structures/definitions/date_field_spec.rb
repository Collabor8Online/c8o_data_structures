require "rails_helper"

module DataStructures
  module Definitions
    RSpec.describe DateField do
      describe ".new" do
        it "sets the caption" do
          field = described_class.new caption: "When it happened"
          expect(field.caption).to eq "When it happened"
        end

        it "sets required" do
          field = described_class.new caption: "When it happened", required: true
          expect(field).to be_required
        end

        it "sets the default value" do
          field = described_class.new caption: "When it happened", default: "today"
          expect(field.default).to eq "today"
        end

        it "sets the description" do
          field = described_class.new caption: "When it happened", description: "It's a date"
          expect(field.description).to eq "It's a date"
        end
      end

      describe "#caption" do
        it "is required" do
          expect { described_class.new caption: nil }.to raise_error(ArgumentError)
        end
      end

      describe "#description" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "When it happened").description).to eq ""
        end
      end

      describe "#required?" do
        it "is false by default" do
          expect(described_class.new(caption: "When it happened")).to_not be_required
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "When it happened").default).to eq ""
        end
      end
    end
  end
end
