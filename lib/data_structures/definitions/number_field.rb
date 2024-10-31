module DataStructures
  module Definitions
    class NumberField < Field
      attribute :default, :integer
      validates_numericality_of :default, only_integer: true, allow_nil: true
      attribute :minimum, :integer
      validates_numericality_of :minimum, only_integer: true, allow_nil: true
      attribute :maximum, :integer
      validates_numericality_of :maximum, only_integer: true, allow_nil: true
    end
  end
end
