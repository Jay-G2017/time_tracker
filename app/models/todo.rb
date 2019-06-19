class Todo < ApplicationRecord
  belongs_to :project
  belongs_to :title, optional: :true

  has_many :tomatoes, dependent: :destroy

  def today_tomatoes
    tomatoes.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

end
