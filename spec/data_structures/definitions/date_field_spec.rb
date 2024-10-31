require "rails_helper"
require_relative "field"

module DataStructures
  module Definitions
    RSpec.describe DateField do
      it_behaves_like "a field"

      describe ".new" do
        it "sets the default value" do
          field = described_class.new caption: "Invoice date", default: "today"
          expect(field.default).to eq "today"
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "First name").default).to eq ""
        end

        describe "legal values" do
          it "allows today"
          it "allows yesterday"
          it "allows tomorrow"
          it "allows a specific date"
          it "allows a number of days from today: 1d"
          it "allows a number of days before today: -1d"
          it "allows a number of weeks from today: 1w"
          it "allows a number of weeks before today: -1w"
          it "allows a number of months from today: 1m"
          it "allows a number of months before today: -1m"
          it "allows a number of years from today: 1y"
          it "allows a number of years before today: -1y"
        end
      end
    end
  end
end
