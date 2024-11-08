require "rails_helper"

module DataStructures
  RSpec.describe RepeatingGroup, type: :model do
    let(:alice) { Person.create(first_name: "Alice", last_name: "Aardvark") }
    let(:container) { Form.create(person: alice, name: "My form") }
    let(:definition_configuration) { {type: "repeating_group", group_items: [{type: "text", caption: "What is your name?", required: true}, {type: "text", caption: "What is your favourite ice cream?", required: false}]} }

    describe "#create_field" do
      subject(:repeating_group) { described_class.new container: container, definition_configuration: definition_configuration }

      it "creates a field for the repeating group, one for the first group within it and one for each of the fields within the group items" do
        repeating_group_field = repeating_group.definition.create_field(container: container)
        expect(repeating_group_field.fields.size).to eq 1
        group = repeating_group_field.groups.first
        expect(group.fields.size).to eq 2
      end
    end

    describe "#add_group" do
      subject(:repeating_group) { described_class.create! container: container, definition_configuration: definition_configuration }

      it "adds a group to the repeating group" do
        repeating_group.add_group
        expect(repeating_group.reload.groups.size).to eq 2

        first_group = repeating_group.groups.first
        expect(first_group.fields.size).to eq 2

        second_group = repeating_group.groups.second
        expect(second_group.fields.size).to eq 2
      end
    end

    describe "#remove_group" do
      subject(:repeating_group) { described_class.create! container: container, definition_configuration: definition_configuration }

      it "removes the last group from the repeating group" do
        3.times { repeating_group.add_group }
        last_group = repeating_group.reload.groups.last

        repeating_group.remove_group
        expect(repeating_group.reload.groups).to_not include(last_group)
      end

      it "does not remove the group if there is only one group configured" do
        last_group = repeating_group.reload.groups.last

        repeating_group.remove_group
        expect(repeating_group.reload.groups.size).to eq 1
        expect(repeating_group.groups).to include(last_group)
      end
    end
  end
end
