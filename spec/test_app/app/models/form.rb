class Form < ApplicationRecord
  include DataStructures::Container

  belongs_to :person
end
