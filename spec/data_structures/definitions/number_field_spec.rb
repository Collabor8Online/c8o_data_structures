require "rails_helper"
require_relative "field"

module DataStructures
  module Definitions
    RSpec.describe NumberField do
      it_behaves_like "a field"

      describe ".new" do
        it "sets the default value" do
          expect(described_class.new(caption: "How many fingers am I holding up?", default: 4).default).to eq 4
        end

        it "sets the minimum value" do
          expect(described_class.new(caption: "How many fingers am I holding up?", minimum: 0).minimum).to eq 0
        end

        it "sets the maximum value" do
          expect(described_class.new(caption: "How many fingers am I holding up?", maximum: 10).maximum).to eq 10
        end
      end

      describe "#default" do
        it "defaults to nil" do
          expect(described_class.new(caption: "How many fingers am I holding up?").default).to be_nil
        end

        it "must be an integer" do
          expect(described_class.new(caption: "Allowed", default: 999)).to be_valid
        end

        it "coerces non-integer values" do
          expect(described_class.new(caption: "Not allowed", default: 123.45).default).to eq 123
          expect(described_class.new(caption: "Not allowed", default: "not an integer").default).to eq 0
        end
      end

      describe "#minimum" do
        it "defaults to nil" do
          expect(described_class.new(caption: "How many fingers am I holding up?").minimum).to be_nil
        end

        it "must be an integer" do
          expect(described_class.new(caption: "Allowed", minimum: 999)).to be_valid
        end

        it "coerces non-integer values" do
          expect(described_class.new(caption: "Not allowed", minimum: 123.45).minimum).to eq 123
          expect(described_class.new(caption: "Not allowed", minimum: "not an integer").minimum).to eq 0
        end
      end

      describe "#maximum" do
        it "defaults to nil" do
          expect(described_class.new(caption: "How many fingers am I holding up?").maximum).to be_nil
        end

        it "must be an integer" do
          expect(described_class.new(caption: "Allowed", maximum: 999)).to be_valid
        end

        it "coerces non-integer values" do
          expect(described_class.new(caption: "Not allowed", maximum: 123.45).maximum).to eq 123
          expect(described_class.new(caption: "Not allowed", maximum: "not an integer").maximum).to eq 0
        end
      end
    end
  end
end
