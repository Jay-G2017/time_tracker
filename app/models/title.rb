class Title < ApplicationRecord
  belongs_to :project
  has_many :todos
end
