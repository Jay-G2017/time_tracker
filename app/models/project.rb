class Project < ApplicationRecord
  has_many :todos, dependent: :destroy
  has_many :titles, dependent: :destroy
  belongs_to :category
  belongs_to :user

  before_validation :set_user, on: :create

  def tomatos_count
    Tomato.where(todo_id: todo_ids).count
  end

  private
  def set_user
    self.user = self.category.user
  end
end
