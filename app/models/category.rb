class Category < ApplicationRecord
  has_many :projects
  belongs_to :user
  after_destroy :set_child_projects_category_nil

  def undone_projects
    projects.where(done: false)
  end

  def starred_projects
    projects.where(starred: true, done: false)
  end

  private
  def set_child_projects_category_nil
    self.projects.update_all(category_id: nil)
  end
end
