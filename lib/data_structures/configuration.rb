module DataStructures
  class Configuration
    include Plumbing::Actor
    async :[], :set, :reset, :register, :class_for, :type_for

    def initialize = reset

    private

    def [](name) = @template_collections[name.to_s] ||= TemplateCollection.start(as_actor)

    def register name, class_or_name
      klass = class_or_name.is_a?(String) ? Object.const_get(class_or_name) : class_or_name
      @class_registrations[name.to_s] = klass
    end

    def class_for(name) = @class_registrations[name.to_s] || raise(NameError, "Unregistered data structure type: #{name}")

    def type_for(klass) = @class_registrations.key(klass)

    def set(name, template_collection) = @template_collections[name.to_s] = template_collection

    def register_default_types = DEFAULT_TYPES.each { |name, class_name| register name, class_name }

    DEFAULT_TYPES = {
      template: "DataStructures::Template",
      section: "DataStructures::Definitions::Section",
      repeating_group: "DataStructures::Definitions::RepeatingGroup",
      heading: "DataStructures::Definitions::Heading",
      sub_heading: "DataStructures::Definitions::SubHeading",
      text: "DataStructures::Definitions::TextField",
      rich_text: "DataStructures::Definitions::RichTextField",
      number: "DataStructures::Definitions::NumberField",
      date: "DataStructures::Definitions::DateField",
      signature: "DataStructures::Definitions::SignatureField"
    }.freeze
    private_constant :DEFAULT_TYPES

    def reset
      @template_collections = {}
      @class_registrations = {}
      register_default_types
    end
  end
end
