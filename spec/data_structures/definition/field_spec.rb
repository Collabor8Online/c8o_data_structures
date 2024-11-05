require "rails_helper"
require_relative "field"

module DataStructures
  class Definition
    RSpec.describe Field do
      describe ".on_validation" do
        subject(:definition) { described_class }

        context "when a custom validator is defined" do
          it "sets the validator" do
            definition.on_validation do |item|
              :fake_result
            end

            expect(definition.validator).to be_a(Proc)
            expect(definition.validator.call(:item)).to eq :fake_result
            expect(definition.new.validate_item(:item)).to eq :fake_result
          end
        end

        context "when no custom validator is defined" do
          it "does nothing" do
            expect(definition.new.validate_item(:item)).to be_nil
          end
        end

        after :each do
          definition.instance_variable_set(:@validator, nil)
        end
      end

      describe ".on_set_value" do
        subject(:definition) { described_class }

        context "when a custom setter is defined" do
          it "sets the setter" do
            definition.on_set_value do |item, value|
              value
            end

            expect(definition.setter).to be_a(Proc)
            expect(definition.setter.call(:item, "Hello")).to eq "Hello"
            expect(definition.new.set_value_for(:item, "Hello")).to eq "Hello"
          end
        end

        context "when no custom setter is defined" do
          it "sets the value in the item's JSON" do
            item = double("item", data: {})
            definition.new.set_value_for(item, "Hello")
            expect(item.data["value"]).to eq "Hello"
          end
        end

        after :each do
          definition.instance_variable_set(:@setter, nil)
        end
      end

      describe ".on_get_value" do
        subject(:definition) { described_class }
        let(:item) { double("item", data: {"the_value" => :the_result}) }

        context "when a custom getter is defined" do
          it "sets the getter" do
            definition.on_get_value do |item|
              item.data["the_value"]
            end

            expect(definition.getter).to be_a(Proc)
            expect(definition.getter.call(item)).to eq :the_result
            expect(definition.new.get_value_for(item)).to eq :the_result
          end
        end
        context "when no custom getter is defined" do
        end

        after :each do
          definition.instance_variable_set(:@getter, nil)
        end
      end
    end
  end
end
