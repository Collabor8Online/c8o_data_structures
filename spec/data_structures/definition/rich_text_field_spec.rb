require "rails_helper"
require_relative "field"

module DataStructures
  class Definition
    RSpec.describe RichTextField do
      it_behaves_like "a field"

      describe "item value" do
        subject(:item) { described_class.new caption: "Some field" }
        let(:container) { Form.new }
        let(:field) { item.create_field container: container, definition: subject }

        it "is stored as an ActionText" do
          field.value = "Hello there"
          expect(field.rich_text_value.to_plain_text).to eq "Hello there"
        end
      end

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
