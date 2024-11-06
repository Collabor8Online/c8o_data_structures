require "rails_helper"
require_relative "field_definition"

module DataStructures
  class Definition
    RSpec.describe UrlField do
      describe ".new" do
        it "sets the default value" do
          field = described_class.new caption: "Website", default: "https://example.com"
          expect(field.default).to eq "https://example.com"
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "Website").default).to eq ""
        end
      end

      describe "item" do
        subject(:item) { described_class.new caption: "Website", default: "https://example.com" }

        it_behaves_like "a field definition", legal_values: ["https://www.example.com"], illegal_values: ["Not_a_url"], default: "https://example.com"
      end
    end
  end
end
