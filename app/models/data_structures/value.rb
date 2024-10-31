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

    def definition = DataStructures.load(definition_configuration)

    def definition=(definition)
      self.definition_configuration = definition.as_json["attributes"].merge("type" => DataStructures.type_for(definition.class))
    end

    def child_values = children.order(:position)
  end
end
