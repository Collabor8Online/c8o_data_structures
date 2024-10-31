require "rails_helper"

module DataStructures
  RSpec.describe Container, type: :model do
    subject(:container) { Form.create person: alice, name: "My form" }
    let(:alice) { Person.create first_name: "Alice", last_name: "Aardvark" }
    let!(:first_value) { Value.create container: container, position: 0 }
    let!(:second_value) { Value.create container: container, position: 1 }
    let!(:first_child_value) { Value.create container: container, parent: first_value, position: 0 }
    let!(:second_child_value) { Value.create container: container, parent: first_value, position: 1 }

    describe "#values" do
      it "lists attached values" do
        [first_value, second_value, first_child_value, second_child_value].each do |value|
          expect(container.values).to include value
        end
      end
    end

    describe "#root_values" do
      it "lists attached root values in order" do
        expect(container.root_values.last).to eq second_value
        expect(container.root_values.first).to eq first_value
        expect(container.root_values.size).to eq 2
      end
    end
  end
end
