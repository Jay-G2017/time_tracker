class Title < ApplicationRecord
  belongs_to :project
  has_many :todos, dependent: :destroy
  validates :name, presence: true
end
