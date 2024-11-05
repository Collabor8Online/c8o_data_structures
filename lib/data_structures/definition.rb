module DataStructures
  class Definition
    include ActiveModel::Model
    include ActiveModel::Attributes

    def to_h
      as_json["attributes"].merge("type" => DataStructures.type_for(self.class))
    end

    def validate_item(item)= true

    def set_value_for(item, value)= nil

    def get_value_for(item)= nil

    def create_item(**params)
      self.class.item_creator.nil? ? DataStructures::Item.create!({definition: self}.merge(params)) : self.class.item_creator.call({definition: self}.merge(params))
    end

    class << self
      def on_create_item &block
        @item_creator = block
      end
      attr_reader :item_creator

      def load config
        config = convert_json(config) if config.is_a? String
        config = config.transform_keys(&:to_sym).except(:version)
        type = config.delete(:type) || raise(ArgumentError, "Type must be specified")
        DataStructures.class_for(type).new(**config)
      end

      def dump(definition) = definition.to_h

      private def convert_json(string) = JSON.parse(string, symbolize_names: true)
    end
  end
end
