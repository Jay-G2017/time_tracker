class Todo < ApplicationRecord
  before_validation :set_project

  belongs_to :project
  belongs_to :title

  has_many :tomatoes, dependent: :destroy

  def today_tomatoes
    tomatoes.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  private
  def set_project
    self.project = title.project
  end
end
