module DataStructures
  class ItemLoader
    def call config
      config = config.transform_keys!(&:to_sym).except(:version)
      type = config.delete(:type) || raise(ArgumentError, "Type must be specified")
      DataStructures.class_for(type).new(**config)
    end
  end
end
