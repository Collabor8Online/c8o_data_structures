require "rails_helper"
require_relative "field_definition"

module DataStructures
  class Definition
    RSpec.describe DateField do
      it_behaves_like "a field definition"

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
          it "does not allow arbitrary strings" do
            expect(described_class.new(caption: "First name", default: "NOT A LEGAL VALUE")).to_not be_valid
          end

          it "allows today" do
            expect(described_class.new(caption: "First name", default: "today")).to be_valid
          end

          it "allows a number of days from today: 1d" do
            expect(described_class.new(caption: "First name", default: "1d")).to be_valid
            expect(described_class.new(caption: "First name", default: "200d")).to be_valid
          end

          it "allows a number of days before today: -1d" do
            expect(described_class.new(caption: "First name", default: "-1d")).to be_valid
            expect(described_class.new(caption: "First name", default: "-200d")).to be_valid
          end

          it "allows a number of weeks from today: 1w" do
            expect(described_class.new(caption: "First name", default: "1w")).to be_valid
            expect(described_class.new(caption: "First name", default: "200w")).to be_valid
          end

          it "allows a number of weeks before today: -1w" do
            expect(described_class.new(caption: "First name", default: "-1w")).to be_valid
            expect(described_class.new(caption: "First name", default: "-200w")).to be_valid
          end

          it "allows a number of months from today: 1m" do
            expect(described_class.new(caption: "First name", default: "1m")).to be_valid
            expect(described_class.new(caption: "First name", default: "200m")).to be_valid
          end

          it "allows a number of months before today: -1m" do
            expect(described_class.new(caption: "First name", default: "-1m")).to be_valid
            expect(described_class.new(caption: "First name", default: "-200m")).to be_valid
          end

          it "allows a number of years from today: 1y" do
            expect(described_class.new(caption: "First name", default: "1y")).to be_valid
            expect(described_class.new(caption: "First name", default: "200y")).to be_valid
          end

          it "allows a number of years before today: -1y" do
            expect(described_class.new(caption: "First name", default: "-1y")).to be_valid
            expect(described_class.new(caption: "First name", default: "-200y")).to be_valid
          end
        end
      end
    end
  end
end
