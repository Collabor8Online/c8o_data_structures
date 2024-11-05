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

    def build_field(**params) = self.class.field_class_name.constantize.new({definition: self}.merge(params))

    def create_field(**params)
      build_field(**params).tap do |field|
        field.save
      end
    end

    class << self
      attr_writer :field_class_name

      def field_class_name = @field_class_name ||= "DataStructures::Field"

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
