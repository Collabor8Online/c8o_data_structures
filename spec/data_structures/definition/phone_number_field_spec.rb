require "rails_helper"
require_relative "field_definition"

module DataStructures
  class Definition
    RSpec.describe PhoneNumberField do
      describe ".new" do
        it "sets the default value" do
          field = described_class.new caption: "Phone", default: "0123 456789"
          expect(field.default).to eq "0123 456789"
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "Phone").default).to eq ""
        end
      end

      describe "item" do
        subject(:item) { described_class.new caption: "Phone", default: "0123 456789" }

        it_behaves_like "a field definition", legal_values: ["0123 456789", "+44 7890 123456"], default: "0123 456789"
      end
    end
  end
end
