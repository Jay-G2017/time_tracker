class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :email

  has_many :categories
  has_many :projects

  def pinned_projects 
    projects.where(pin: true)
  end

end
