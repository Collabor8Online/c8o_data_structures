module DataStructures
  class Definition
    class RichTextField < Field
      attribute :default, :string, default: ""

      on_set_value do |item, value|
        item.rich_text_value = value
      end

      on_get_value do |item|
        item.rich_text_value
      end
    end
  end
end
