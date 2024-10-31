require "rails_helper"
require_relative "field"

module DataStructures
  module Definitions
    RSpec.describe TextField do
      it_behaves_like "a field"

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
    end
  end
end
