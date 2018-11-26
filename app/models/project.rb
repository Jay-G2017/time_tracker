class Project < ApplicationRecord
  has_many :todos, dependent: :destroy
  has_many :titles, dependent: :destroy
  belongs_to :category, optional: true
  belongs_to :user

  scope :created_desc, -> { order(created_at: :desc) }
  scope :updated_desc, -> { order(updated_at: :desc) }

  def tomatos_count
    Tomato.where(todo_id: todo_ids).count
  end

end
