require "rails_helper"
require_relative "field_definition"

module DataStructures
  class Definition
    RSpec.describe CurrencyField do
      it_behaves_like "a field definition", legal_values: [-1000.0, 0.0, 1000.0], illegal_values: ["some text", Date.today]

      describe "field value" do
        subject(:definition) { described_class.new caption: "Some field" }
        let(:container) { Form.new }
        let(:field) { definition.create_field container: container, definition: subject }

        it "is stored as a float" do
          field.value = 99.00
          expect(field.data["value"]).to eq 99.00
        end

        it "converts integer values to floats" do
          field.value = 45
          expect(field.data["value"]).to eq 45.00
        end
      end

      describe ".new" do
        it "sets the default value" do
          expect(described_class.new(caption: "How much is the rug?", default: 4.0).default).to eq 4.0
        end

        it "sets the minimum value" do
          expect(described_class.new(caption: "How much is the rug?", minimum: 0.0).minimum).to eq 0.0
        end

        it "sets the maximum value" do
          expect(described_class.new(caption: "How much is the rug?", maximum: 10.0).maximum).to eq 10.0
        end
      end

      describe "#default" do
        it "defaults to nil" do
          expect(described_class.new(caption: "How much is the rug?").default).to be_nil
        end

        it "must be a float" do
          expect(described_class.new(caption: "Allowed", default: 999.0)).to be_valid
        end

        it "coerces non-float values" do
          expect(described_class.new(caption: "Not allowed", default: 123).default).to eq 123.0
          expect(described_class.new(caption: "Not allowed", default: "not a float").default).to eq 0.0
        end

        describe "item value" do
          subject(:definition) { described_class.new caption: "Some field", default: 123.0 }
          let(:container) { Form.new }
          let(:field) { definition.create_field container: container, definition: subject }

          it_behaves_like "a field definition", legal_values: [-1000, 0, 1000], illegal_values: ["some text", Date.today], default: 123.0
        end
      end

      describe "#minimum" do
        it "defaults to nil" do
          expect(described_class.new(caption: "How much is the rug?").minimum).to be_nil
        end

        it "must be a float" do
          expect(described_class.new(caption: "Allowed", minimum: 999.0)).to be_valid
        end

        it "coerces non-float values" do
          expect(described_class.new(caption: "Not allowed", minimum: 123).minimum).to eq 123.0
          expect(described_class.new(caption: "Not allowed", minimum: "not a float").minimum).to eq 0.0
        end

        describe "field value" do
          subject(:definition) { described_class.new caption: "Some field", minimum: 100.0 }

          it_behaves_like "a field definition", legal_values: [100.0, 101.0, 102.0], illegal_values: [-1.0, 0.0, 99.999]
        end
      end

      describe "#maximum" do
        it "defaults to nil" do
          expect(described_class.new(caption: "How much is the rug?").maximum).to be_nil
        end

        it "must be an integer" do
          expect(described_class.new(caption: "Allowed", maximum: 999.9)).to be_valid
        end

        it "coerces non-float values" do
          expect(described_class.new(caption: "Not allowed", maximum: 123).maximum).to eq 123.0
          expect(described_class.new(caption: "Not allowed", maximum: "not a float").maximum).to eq 0.0
        end

        describe "item" do
          subject(:definition) { described_class.new caption: "Some field", maximum: 100.0 }

          it_behaves_like "a field definition", legal_values: [-1.99, 99.99, 100.0], illegal_values: [101.0, 102.0, 103.0]
        end
      end
    end
  end
end
