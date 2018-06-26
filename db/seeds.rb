# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
project = Project.create({ name: 'Coding' })
title = Title.create(name: 'Front-end')
title.project = project

todos = ['html', 'css', 'javascript']
todos.each do |todo_name|
  todo = Todo.new(name: todo_name)
  todo.title = title
  todo.project = project
  todo.save
end


title2 = Title.create(name: 'Back-end')
title2.project = project

backend_todos = ['ruby', 'rails', 'linux']
backend_todos.each do |todo_name|
  todo = Todo.new(name: todo_name)
  todo.title = title2
  todo.project = project
  todo.save
end

