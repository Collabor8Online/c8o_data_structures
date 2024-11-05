require "rails_helper"
require_relative "container"

module DataStructures
  class Definition
    RSpec.describe RepeatingGroup do
      it "creates a set of group items based on the configuration" do
        repeating_group = described_class.new(group_items: [{type: "text", caption: "First name"}, {type: "text", caption: "Last name", required: true}])
        expect(repeating_group.group_items.size).to eq 2

        first_name = repeating_group.group_items[0]
        expect(first_name).to be_kind_of(DataStructures::Definition::TextField)
        expect(first_name.caption).to eq "First name"
        expect(first_name).to_not be_required

        last_name = repeating_group.group_items[1]
        expect(last_name).to be_kind_of(DataStructures::Definition::TextField)
        expect(last_name.caption).to eq "Last name"
        expect(last_name).to be_required
      end

      it "has an empty set of group items by default" do
        repeating_group = described_class.new
        expect(repeating_group.group_items).to be_empty
      end

      it "has a single repeat item that contains the group items" do
        repeating_group = described_class.new(group_items: [{type: "text", caption: "First name"}, {type: "text", caption: "Last name", required: true}])

        expect(repeating_group.items.size).to eq 1
        repeat = repeating_group.items.first
        expect(repeat).to be_kind_of(DataStructures::Definition::Repeat)

        expect(repeat.items.size).to eq 2
        expect(repeat.items.first).to be_kind_of(DataStructures::Definition::TextField)
        expect(repeat.items.second).to be_kind_of(DataStructures::Definition::TextField)
      end
    end
  end
end
