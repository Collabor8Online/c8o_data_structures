module DataStructures
  class Definition
    include ActiveModel::Model
    include ActiveModel::Attributes
    attr_reader :parent_path

    def initialize(parent_path: "", position: 0, **)
      super(**)
      @position = position
      @parent_path = parent_path.to_s
    end

    def path = "#{@parent_path}/#{self}"

    def to_s = @position.to_s

    def to_h = as_json["attributes"].merge("type" => DataStructures.type_for(self.class))

    def validate_field(field)= true

    def set_value_for(field, value)= nil

    def get_value_for(field)= nil

    def build_field(**params) = self.class.field_class_name.constantize.new({definition: self}.merge(params))

    def create_field(**params)
      build_field(**params).tap do |field|
        field.save
      end
    end

    class << self
      attr_writer :field_class_name

      def field_class_name = @field_class_name ||= "DataStructures::Field"

      def load config, parent_path: "", position: 0
        config = convert_json(config) if config.is_a? String
        config = config.transform_keys(&:to_sym).except(:version)
        type = config.delete(:type) || raise(ArgumentError, "Type must be specified")
        DataStructures.class_for(type).new(**config.merge(parent_path: parent_path, position: position))
      end

      def dump(definition) = definition.to_h

      private def convert_json(string) = JSON.parse(string, symbolize_names: true)
    end
  end
end
