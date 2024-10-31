module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :values, as: :container, dependent: :destroy_async
    end
  end
end
