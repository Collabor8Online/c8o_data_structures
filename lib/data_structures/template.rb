module DataStructures
  class Template
    include ActiveModel::Model
    include ActiveModel::Attributes
    attribute :name, :string
    validates :name, presence: true
    attribute :description, :string, default: ""
    attr_reader :items

    def initialize(items: [], **)
      super(**)
      @items = load_items_from items
    end

    private

    def load_items_from(config) = config.map { |item_data| DataStructures.load item_data }.freeze
  end
end
