class Todo < ApplicationRecord
  before_validation :set_project

  belongs_to :project
  belongs_to :title

  has_many :tomatoes

  private
  def set_project
    self.project = title.project
  end
end
