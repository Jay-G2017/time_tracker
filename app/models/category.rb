class Category < ApplicationRecord
  has_many :projects, dependent: :destroy
  belongs_to :user
end
