namespace :fake do
  task category: :environment do
    user = User.find_by_email('admin')
    50.times do
      user.categories.create!(name: Faker::Food.fruits)
    end
  end

  task projects: :environment do
    user = User.find_by_email('admin')
    category = user.categories.first
    50.times do
      category.projects.create!(name: Faker::Food.fruits)
    end
  end

  task first_project: :environment do
    user = User.find_by_email('admin')
    project = user.projects.first
    10.times do
      title = project.titles.create!(name: Faker::Food.fruits)
      5.times do
        title.todos.create!(name: Faker::Food.ingredient)
      end
    end
  end

end
