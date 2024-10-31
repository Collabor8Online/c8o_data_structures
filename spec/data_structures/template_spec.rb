require "rails_helper"

module DataStructures
  RSpec.describe Template do
    describe ".new" do
      it "sets the name and description" do
        template = described_class.new name: "My template", description: "A template for testing"
        expect(template.name).to eq "My template"
        expect(template.description).to eq "A template for testing"
      end

      it "creates a set of items based on the configuration" do
        template = described_class.new name: "My template", description: "A template for testing", items: [
          {type: "text", caption: "First name"},
          {type: "text", caption: "Last name", required: true}
        ]
        expect(template.items.size).to eq 2

        first_name = template.items[0]
        expect(first_name).to be_kind_of(DataStructures::Definitions::TextField)
        expect(first_name.caption).to eq "First name"
        expect(first_name).to_not be_required

        last_name = template.items[1]
        expect(last_name).to be_kind_of(DataStructures::Definitions::TextField)
        expect(last_name.caption).to eq "Last name"
        expect(last_name).to be_required
      end
    end

    describe "#name" do
      it "is required" do
        expect(described_class.new(name: nil, description: "A template for testing")).to_not be_valid
      end
    end

    describe "#description" do
      it "defaults to an empty string" do
        expect(described_class.new(name: "My template").description).to eq ""
      end
    end
  end
end
