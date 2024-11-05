RSpec.shared_examples "a field" do |default: nil, legal_values: [], illegal_values: []|
  describe ".new" do
    it "sets the caption" do
      field = described_class.new caption: "A caption"
      expect(field.caption).to eq "A caption"
    end

    it "sets required" do
      field = described_class.new caption: "A caption", required: true
      expect(field).to be_required
    end

    it "sets the description" do
      field = described_class.new caption: "A caption", description: "The description"
      expect(field.description).to eq "The description"
    end
  end

  describe "#caption" do
    it "is required" do
      expect(described_class.new(caption: nil)).to_not be_valid
    end
  end

  describe "#description" do
    it "defaults to an empty string" do
      expect(described_class.new(caption: "A caption").description).to eq ""
    end
  end

  describe "#required?" do
    it "is false by default" do
      expect(described_class.new(caption: "A caption")).to_not be_required
    end
  end

  describe "validity" do
    let(:container) { Form.new }
    let(:item) { subject.create_item container: container, definition: subject }

    it "is valid if given legal values" do
      legal_values.each do |value|
        item.value = value
        expect(item).to be_valid
      end
    end

    it "is invalid if given illegal values" do
      illegal_values.each do |value|
        item.value = value
        expect(item).to_not be_valid
        expect(item.errors).to include(:value)
      end
    end

    if default.nil?
      context "when not configured with a default value" do
        context "when the field is required" do
          before do
            subject.required = true
          end

          it "is invalid" do
            item = DataStructures::Item.create container: container, definition: subject

            expect(item).to_not be_valid
            expect(item.errors).to include(:value)
          end
        end

        context "when the field is not required" do
          before do
            subject.required = false
          end

          it "is valid" do
            item = DataStructures::Item.create container: container, definition: subject

            expect(item).to be_valid
          end
        end
      end
    end
  end

  describe "value" do
    let(:container) { Form.new }
    let(:item) { DataStructures::Item.create! container: container, definition: subject }

    it "sets and reads the values of the item" do
      legal_values.each do |value|
        item.value = value
        expect(item.value).to eq value
      end
    end

    if !default.nil?
      context "when configured with a default value" do
        it "returns the default value" do
          expect(item.value).to eq default
        end
      end
    end
  end
end
