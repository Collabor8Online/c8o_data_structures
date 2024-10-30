require "rails_helper"

module DataStructures
  module Definitions
    RSpec.describe SignatureField do
      describe ".new" do
        it "sets the caption" do
          field = described_class.new caption: "Sign here"
          expect(field.caption).to eq "Sign here"
        end

        it "sets required" do
          field = described_class.new caption: "Sign here", required: true
          expect(field).to be_required
        end

        it "sets the description" do
          field = described_class.new caption: "Sign here", description: "and I will own all your possessions"
          expect(field.description).to eq "and I will own all your possessions"
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
    end
  end
end
