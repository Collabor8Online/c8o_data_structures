require "ancestry"

module DataStructures
  class Item < ApplicationRecord
    has_ancestry
    def items = children.order(:position)

    belongs_to :container, polymorphic: true
    validate :container do |item|
      item.errors.add :container, :is_not_a_container unless item.container.is_a? DataStructures::Container
    end
    after_save :create_items_for_definition, if: :saved_change_to_definition_configuration?

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
    validate :value do |item|
      definition&.validate_item(item)
    end

    serialize :data, type: Hash, coder: JSON
    has_rich_text :rich_text_value
    has_one_attached :attachment_value
    has_many_attached :attachment_values
    belongs_to :model, polymorphic: true, optional: true

    private

    def create_items_for_definition
      return unless definition.respond_to? :items
      items.where(position: definition.items.size..).destroy_all
      definition.items.each_with_index do |item, position|
        items.where(position: position).first_or_initialize.update! container: container, parent: self, definition: item
      end
    end
  end
end
