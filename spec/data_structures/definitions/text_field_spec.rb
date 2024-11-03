require "rails_helper"
require_relative "field"

module DataStructures
  class Definition
    RSpec.describe TextField do
      describe ".new" do
        it "sets the default value" do
          field = described_class.new caption: "First name", default: "John"
          expect(field.default).to eq "John"
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "First name").default).to eq ""
        end
      end

      describe "item value" do
        subject(:item) { described_class.new caption: "Some field", default: "BOOM" }

        it_behaves_like "a field", legal_values: ["some text", "some other text", 123, Date.today], default: "BOOM"
      end
    end
  end
end
