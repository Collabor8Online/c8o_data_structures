module DataStructures
  class Definition
    include ActiveModel::Model
    include ActiveModel::Attributes
    attribute :parent_path, :string, default: ""
    attribute :position, :integer, default: 0

    def to_s = "#{model_name.element}:#{position}"

    def to_h = as_json["attributes"].merge("type" => DataStructures.type_for(self.class))

    def path_name = position.to_s

    def path = "#{parent_path}/#{path_name}"

    def validate_field(field)= true

    def set_value_for(field, value)= nil

    def get_value_for(field)= nil

    def build_field(**params) = self.class.field_class_name.constantize.new({definition: self}.merge(params))

    def create_field(**params)
      build_field(**params).tap { |f| f.save }
    end

    class << self
      attr_writer :field_class_name

      def field_class_name = @field_class_name ||= "DataStructures::Field"

      def load config, parent_path: "", position: 1
        config = convert_json(config) if config.is_a? String
        config = config.transform_keys(&:to_sym).except(:version)
        type = config.delete(:type) || raise(ArgumentError, "Type must be specified")
        DataStructures.class_for(type).new(**config.reverse_merge(parent_path: parent_path, position: position))
      end

      def dump(definition) = definition.to_h

      private def convert_json(string) = JSON.parse(string, symbolize_names: true)
    end
  end
end
