module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :_fields, as: :container, inverse_of: :container, class_name: "DataStructures::Field", dependent: :destroy_async
      has_many :fields, -> { roots.order(:position) }, inverse_of: :container, class_name: "DataStructures::Field", as: :container
      accepts_nested_attributes_for :fields
    end

    def field(field_name) = _fields.find_by field_name: field_name

    def find_all_fields(reference) = _fields.select { |field| field.definition.reference == reference }

    def create_fields_for definition
      return unless definition.respond_to? :items
      definition.items.each_with_index do |field_definition, position|
        existing_field = field field_definition.reference
        existing_field.present? ? update_existing_field(existing_field, field_definition, position + 1) : create_field_from(field_definition, position + 1)
      end
    end

    private

    def update_existing_field(field, field_definition, position) = field.update position: position, definition: field_definition

    def create_field_from(field_definition, position) = field_definition.create_field position: position, container: self
  end
end
