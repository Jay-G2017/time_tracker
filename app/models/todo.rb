class Todo < ApplicationRecord
  before_validation :set_project

  belongs_to :project
  belongs_to :title

  private
  def set_project
    self.project = title.project
  end
end
