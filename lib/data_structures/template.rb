module DataStructures
  class Template
    def initialize name:, description: "", items: []
      @name = name || raise(ArgumentError, "name is required")
      @description = description || ""
      @items = load_items_from(items)
    end
    attr_reader :name, :description, :items

    private

    def load_items_from config
      config.map { |item_data| load_item_from(item_data) }
    end

    def load_item_from item_data
      item_data.delete(:version)
      type = item_data.delete(:type)
      DataStructures.class_for(type).new(**item_data)
    end
  end
end
