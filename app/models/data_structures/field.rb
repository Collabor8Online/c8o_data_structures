require "ancestry"

module DataStructures
  class Field < ApplicationRecord
    has_ancestry
    def fields = children.order(:position)

    def fields_attributes=(params)
      params.values.collect { |param| fields.find(param.delete(:id)).update param }
    end

    belongs_to :container, polymorphic: true
    validate :container do |item|
      item.errors.add :container, :is_not_a_container unless item.container.is_a? DataStructures::Container
    end
    after_save :create_fields_for_definition, if: :saved_change_to_definition_configuration?

    serialize :definition_configuration, type: Hash, coder: JSON
    attribute :definition
    def definition = @definition ||= DataStructures::Definition.load(definition_configuration)

    def definition=(definition)
      @definition = definition
      self.definition_configuration = Definition.dump(definition)
    end

    attribute :value
    def value = definition.get_value_for(self)

    def value=(value)
      definition.set_value_for(self, value)
    end
    validate :value, on: :update do |field|
      definition&.validate_field(field)
    end

    serialize :data, type: Hash, coder: JSON
    has_rich_text :rich_text_value
    has_one_attached :attachment_value
    has_many_attached :attachment_values
    belongs_to :model, polymorphic: true, optional: true

    def next_position = fields.size

    private

    def create_fields_for_definition
      return unless definition.respond_to? :items
      definition.items.each_with_index do |item_definition, position|
        fields.find_by(position: position) || item_definition.create_field(position: position, container: container, parent: self, definition: item_definition)
      end
    end
  end
end
