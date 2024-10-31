class Person < ApplicationRecord
  has_many :forms, dependent: :destroy
end
