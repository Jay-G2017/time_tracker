class Project < ApplicationRecord
  has_many :todos
  has_many :titles
  belongs_to :category
end
