class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :email

  has_many :categories
  has_many :projects

  def inbox_projects
    projects.where(category_id: nil)
  end

  def starred_projects
    projects.where(starred: true)
  end

  def done_projects
    projects.where(done: true)
  end

  def today_tomato_size
    num = 0
    projects.each do |project|
      project.todos.each do |todo|
        num += todo.today_tomatoes.size
      end
    end
    num
  end

end
