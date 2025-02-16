require "rails_helper"
require_relative "field_definition"

module DataStructures
  class Definition
    RSpec.describe EmailField do
      describe ".new" do
        it "sets the default value" do
          field = described_class.new caption: "Email", default: "someone@example.com"
          expect(field.default).to eq "someone@example.com"
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "Email").default).to eq ""
        end
      end

      describe "field" do
        subject(:field) { described_class.new caption: "Email" }

        it_behaves_like "a field definition", legal_values: ["alice@example.com", "bob@some-odd.place.with.tld"], illegal_values: ["Not_an_email", 123]
      end
    end
  end
end
