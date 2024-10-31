module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :values, as: :container, class_name: "DataStructures::Value", dependent: :destroy_async
    end

    def root_values = values.roots.order :position
  end
end
