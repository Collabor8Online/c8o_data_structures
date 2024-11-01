module DataStructures
  class Definition
    include ActiveModel::Model
    include ActiveModel::Attributes

    def self.load config
      config = config.transform_keys(&:to_sym).except(:version)
      type = config.delete(:type) || raise(ArgumentError, "Type must be specified")
      DataStructures.class_for(type).new(**config)
    end

    def self.dump definition
      definition.as_json["attributes"].merge("type" => DataStructures.type_for(definition.class)).tap do |config|
        config["items"] = definition.items.map { |item| dump(item) } if definition.respond_to? :items
      end
    end
  end
end
