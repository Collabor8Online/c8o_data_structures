require "ancestry"

module DataStructures
  class Field < ApplicationRecord
    has_ancestry
    belongs_to :container, polymorphic: true

    serialize :data, type: Hash, coder: JSON
    has_rich_text :rich_text_value
    has_one_attached :attachment_value
    has_many_attached :attachment_values
    belongs_to :model, polymorphic: true, optional: true
    serialize :definition_configuration, type: Hash, coder: JSON
    attribute :definition
    def definition = @definition ||= DataStructures::Definition.load(definition_configuration)

    def definition=(definition)
      @definition = definition
      self.definition_configuration = Definition.dump(@definition)
    end

    attribute :value
    def value = definition.get_value_for(self)

    def value=(value)
      definition.set_value_for(self, value)
    end

    def fields = children.order(:position)

    def caption = definition.respond_to?(:caption) ? definition.caption : ""

    def required? = definition.respond_to?(:required?) ? definition.required? : false

    def next_position = fields.size + 1

    def fields_attributes=(params)
      params.values.collect { |param| fields.find(param.delete(:id)).update param }
    end

    private

    validate :value, on: :update, unless: :definition_configuration_changed? do |field|
      definition&.validate_field(field)
    end

    validate :container do |item|
      item.errors.add :container, :is_not_a_container unless item.container.is_a? DataStructures::Container
    end

    validates :field_name, uniqueness: {scope: :container}

    before_save if: :definition_configuration_changed? do |field|
      @definition = nil # force reload of the definition from the configuration hash
      field.field_name = generate_field_name
    end

    after_save :create_or_update_child_fields, if: :saved_change_to_definition_configuration?

    def create_or_update_child_fields
      return unless definition.respond_to? :items
      definition.items.each_with_index do |field_definition, position|
        existing_field = container.field("#{field_name}/#{field_definition.path_name}")
        existing_field.present? ? update_existing_field(existing_field, field_definition, position + 1) : create_field_from(field_definition, position + 1)
      end
    end

    def update_existing_field(field, field_definition, position) = field.update parent: self, position: position, definition: field_definition

    def create_field_from(field_definition, position) = field_definition.create_field(position: position, container: container, parent: self)

    protected

    def generate_field_name = [parent&.field_name, definition.reference].compact.join("/")
  end
end
