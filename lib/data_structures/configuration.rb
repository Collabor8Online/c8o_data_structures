module DataStructures
  class Configuration
    include Plumbing::Actor
    async :[], :set, :reset, :register, :class_for

    def initialize
      reset
      register_types
    end

    private

    def [](name) = @template_collections[name.to_s] ||= TemplateCollection.start(as_actor)

    def register name, class_or_name
      klass = class_or_name.is_a?(String) ? Object.const_get(class_or_name) : class_or_name
      @class_registrations[name.to_s] = klass
    end

    def class_for(name) = @class_registrations[name.to_s]

    def set(name, template_collection) = @template_collections[name.to_s] = template_collection

    def register_types = DEFAULT_TYPES.each { |name, class_name| register name, class_name }

    DEFAULT_TYPES = {
      template: "DataStructures::Template"
    }.freeze
    private_constant :DEFAULT_TYPES

    def reset
      @template_collections = {}
      @class_registrations = {}
    end
  end
end
