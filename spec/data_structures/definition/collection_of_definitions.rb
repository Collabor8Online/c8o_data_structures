RSpec.shared_examples "a collection of definitions" do |default_params|
  it "creates a set of items based on the configuration" do
    container = described_class.new(**default_params.merge(items: [{type: "text", caption: "First name"}, {type: "text", caption: "Last name", required: true}]))
    expect(container.items.size).to eq 2

    first_name = container.items[0]
    expect(first_name).to be_kind_of(DataStructures::Definition::TextField)
    expect(first_name.caption).to eq "First name"
    expect(first_name).to_not be_required

    last_name = container.items[1]
    expect(last_name).to be_kind_of(DataStructures::Definition::TextField)
    expect(last_name.caption).to eq "Last name"
    expect(last_name).to be_required
  end

  it "has an empty set of items by default" do
    container = described_class.new(**default_params)
    expect(container.items).to be_empty
  end
end
