require "rails_helper"
require_relative "field"

module DataStructures
  class Definition
    RSpec.describe DropDownField do
      it_behaves_like "a field"

      describe ".new" do
        it "sets the options" do
          field = described_class.new caption: "Choose an option", options: {"one" => "Option one", "two" => "Option two"}
          expect(field.options).to eq({"one" => "Option one", "two" => "Option two"})
        end

        it "sets the options with string keys" do
          field = described_class.new caption: "Choose an option", options: {one: "Option one", two: "Option two"}
          expect(field.options).to eq({"one" => "Option one", "two" => "Option two"})
        end

        it "sets the default value" do
          field = described_class.new caption: "Choose an option", default: "one", options: {one: "Option one", two: "Option two"}
          expect(field.default).to eq "one"
        end
      end

      describe "#default" do
        it "defaults to an empty string" do
          expect(described_class.new(caption: "Choose an option", options: {one: "Option one", two: "Option two"}).default).to eq ""
        end

        context "default is set" do
          it "must be a key in the options" do
            expect(described_class.new(caption: "Choose an option", options: {one: "Option one", two: "Option two"}, default: "two")).to be_valid
            expect(described_class.new(caption: "Choose an option", options: {one: "Option one", two: "Option two"}, default: "three")).to_not be_valid
          end
        end

        context "default is not set" do
          it "is valid regardless of options" do
            expect(described_class.new(caption: "Choose an option", options: {one: "Option one", two: "Option two"}, default: "")).to be_valid
          end
        end
      end
    end
  end
end
