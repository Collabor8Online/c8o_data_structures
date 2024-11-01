require "ancestry"

module DataStructures
  class Value < ApplicationRecord
    has_ancestry
    belongs_to :container, polymorphic: true
    serialize :definition_configuration, type: Hash, coder: JSON
    serialize :data, type: Hash, coder: JSON
    has_rich_text :rich_text_value
    has_one_attached :attachment_value
    has_many_attached :attachment_values
    belongs_to :model, polymorphic: true, optional: true
    validate :container do |value|
      value.errors.add :container, :is_not_a_container unless value.container.is_a? DataStructures::Container
    end
    after_save if: :saved_change_to_definition_configuration? do
      create_values_for definition if definition.respond_to? :items
    end

    def definition = @definition ||= DataStructures::Definition.load(definition_configuration)

    def definition=(definition)
      @definition = definition
      self.definition_configuration = Definition.dump(definition)
    end

    def values = children.order(:position)

    private

    def create_values_for definition
      values.where(position: definition.items.size..).destroy_all
      definition.items.each_with_index do |item, position|
        values.where(position: position).first_or_initialize.update! container: container, parent: self, definition: item
      end
    end
  end
end
