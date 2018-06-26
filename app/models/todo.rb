class Todo < ApplicationRecord
  belongs_to :project
  belongs_to :title
end
