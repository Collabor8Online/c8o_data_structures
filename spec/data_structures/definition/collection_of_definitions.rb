RSpec.shared_examples "a collection of definitions" do |default_params|
  describe "#items" do
    it "creates a set of items based on the configuration" do
      container = described_class.new(**default_params.merge(items: [{type: "text", caption: "First name"}, {type: "text", caption: "Last name", required: true}]))
      expect(container.items.size).to eq 2

      base_path = container.path.blank? ? "" : "#{container.path}/"

      first_name = container.items[0]
      expect(first_name).to be_kind_of(DataStructures::Definition::TextField)
      expect(first_name.caption).to eq "First name"
      expect(first_name).to_not be_required
      expect(first_name.path).to eq "#{base_path}first_name"

      last_name = container.items[1]
      expect(last_name).to be_kind_of(DataStructures::Definition::TextField)
      expect(last_name.caption).to eq "Last name"
      expect(last_name).to be_required
      expect(last_name.path).to eq "#{base_path}last_name"
    end

    it "has an empty set of items by default" do
      container = described_class.new(**default_params)
      expect(container.items).to be_empty
    end
  end

  describe "#path" do
    it "returns its path_name as it's path" do
      container = described_class.new(**default_params.merge(parent_path: "my_template", position: 1))
      expect(container.path).to eq "my_template/#{container.path_name}"
    end
  end

  describe "#all_items" do
    it "returns all items, including nested items" do
      container = described_class.new(**default_params.merge(position: 0, items: [{type: "section", position: 0, items: [{type: "text", caption: "First name"}, {type: "text", caption: "Last name", required: true}]}]))
      base_path = container.path.blank? ? "" : "#{container.path}/"

      all_items = container.all_items

      expect(all_items.size).to eq 3
      all_paths = all_items.map(&:path)
      expect(all_paths).to include "#{base_path}0"
      expect(all_paths).to include "#{base_path}0/first_name"
      expect(all_paths).to include "#{base_path}0/last_name"
    end
  end

  describe "#find" do
    it "finds an item by its path" do
      container = described_class.new(**default_params.merge(items: [{type: "text", caption: "First name"}, {type: "text", caption: "Last name", required: true}], parent_path: "my_template", position: 3))

      first_name = container.find "my_template/#{container.path_name}/first_name"
      expect(first_name).to be_kind_of(DataStructures::Definition::TextField)
      expect(first_name.caption).to eq "First name"
      expect(first_name).to_not be_required

      last_name = container.find "my_template/#{container.path_name}/last_name"
      expect(last_name).to be_kind_of(DataStructures::Definition::TextField)
      expect(last_name.caption).to eq "Last name"
      expect(last_name).to be_required
    end
  end

  if !described_class === DataStructures::Definition::Template
    describe "#path_name" do
      it "returns its position" do
        container = described_class.new(**default_params.merge(parent_path: "my_template", position: 1))
        expect(container.path_name).to eq "1"
      end
    end
  end

  describe "#path" do
    it "is generated from the parent path and path name" do
      container = described_class.new(**default_params.merge(parent_path: "my_template", position: 1))
      expect(container.path).to eq "my_template/#{container.path_name}"
    end
  end
end
