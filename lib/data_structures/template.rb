module DataStructures
  class Template
    def initialize name:, description: "", items: []
      @name = name || raise(ArgumentError, "name is required")
      @description = description || ""
      @items = load_items_from(items)
    end
    attr_reader :name, :description, :items

    private

    def load_items_from(config) = config.map { |item_data| DataStructures.load item_data }
  end
end
