class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :email

  has_many :categories
  has_many :projects

  def inbox_projects
    projects.where(category_id: nil, done: false)
  end

  def starred_projects
    projects.where(starred: true, done: false)
  end

  def done_projects
    projects.where(done: true)
  end

  def today_tomatoes
    todo_ids = Todo.where(project_id: project_ids).pluck(:id)
    Tomato.today.where(todo_id: todo_ids)
  end

  def today_tomatoes_size
    today_tomatoes.count
  end

end
