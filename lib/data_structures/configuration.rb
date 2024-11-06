module DataStructures
  class Configuration
    include Plumbing::Actor
    async :[], :set, :reset, :register, :class_for, :type_for, :registered_types, :attributes_for

    def initialize = reset

    private

    def [](name) = @template_collections[name.to_s] ||= TemplateCollection.start(as_actor)

    def register name, class_or_name
      klass = class_or_name.is_a?(String) ? Object.const_get(class_or_name) : class_or_name
      @class_registrations[name.to_s] = klass
    end

    def class_for(name) = @class_registrations[name.to_s] || raise(NameError, "Unregistered data structure type: #{name}")

    def type_for(klass) = @class_registrations.key(klass)

    def registered_types = @class_registrations.keys

    def attributes_for(type) = class_for(type).attribute_names

    def set(name, template_collection) = @template_collections[name.to_s] = template_collection

    def register_default_types = DEFAULT_TYPES.each { |name, class_name| register name, class_name }

    DEFAULT_TYPES = {
      template: "DataStructures::Definition::Template",
      section: "DataStructures::Definition::Section",
      repeating_group: "DataStructures::Definition::RepeatingGroup",
      group: "DataStructures::Definition::Group",
      heading: "DataStructures::Definition::Heading",
      sub_heading: "DataStructures::Definition::SubHeading",
      text: "DataStructures::Definition::TextField",
      rich_text: "DataStructures::Definition::RichTextField",
      number: "DataStructures::Definition::NumberField",
      decimal: "DataStructures::Definition::DecimalField",
      currency: "DataStructures::Definition::CurrencyField",
      date: "DataStructures::Definition::DateField",
      url: "DataStructures::Definition::UrlField",
      email: "DataStructures::Definition::EmailField",
      signature: "DataStructures::Definition::SignatureField"
    }.freeze
    private_constant :DEFAULT_TYPES

    def reset
      @template_collections = {}
      @class_registrations = {}
      register_default_types
    end
  end
end
