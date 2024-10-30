require "rails_helper"

module DataStructures
  module Definitions
    RSpec.describe RichTextField do
      describe ".new" do
        it "sets the caption" do
          field = described_class.new caption: "Tell me more"
          expect(field.caption).to eq "Tell me more"
        end

        it "sets required" do
          field = described_class.new caption: "Tell me more", required: true
          expect(field).to be_required
        end

        it "sets the default value" do
          field = described_class.new caption: "Tell me more", default: "Blah blah blah"
          expect(field.default).to eq "Blah blah blah"
        end

        it "sets the description" do
          field = described_class.new caption: "Tell me more", description: "I need answers"
          expect(field.description).to eq "I need answers"
        end
      end

      describe "#caption" do
        it "is required" do
          expect { described_class.new caption: nil }.to raise_error(ArgumentError)
        end
      end

      describe "#description" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "Tell me more").description).to eq ""
        end
      end

      describe "#required?" do
        it "is false by default" do
          expect(described_class.new(caption: "Tell me more")).to_not be_required
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "Tell me more").default).to eq ""
        end
      end
    end
  end
end
