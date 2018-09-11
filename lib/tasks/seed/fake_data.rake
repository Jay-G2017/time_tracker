namespace :fake do
  task category: :environment do
    user = User.find_by_email('admin')
    50.times do
      user.categories.create!(name: Faker::Food.fruits)
    end
  end

  task project: :environment do
    user = User.find_by_email('admin')
    category = user.categories.first
    50.times do
      category.projects.create!(name: Faker::Food.fruits)
    end
  end
end
