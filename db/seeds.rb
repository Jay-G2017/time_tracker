# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

# 创建一个work分类和下面的todos
ca_work = Category.find_or_create_by(name: 'Work')
project_work = ca_work.projects.create(name: '学习编程')

title1_work = project_work.titles.create(name: '前端Front-end')
todos = ['学习html', '学习css', '学习javascript']
todos.each { |todo_name| title1_work.todos.create(name: todo_name, project_id: project_work.id) }

title2_work = project_work.titles.create(name: '学习后端Back-end')
backend_todos = ['学习ruby', '学习rails', '学习linux']
backend_todos.each { |todo_name| title2_work.todos.create(name: todo_name, project_id: project_work.id) }

# 创建一个home分类和下面的todos
ca_home = Category.find_or_create_by(name: 'Home')
project_home = ca_home.projects.create({ name: '学习烧菜' })
title1_home = project_home.titles.create(name: '红烧肉')
meat_todos = ['将五花肉切成2厘米见方的大块', '倒入刚才煸炒的肉，倒入老抽生抽调好的汁，一碗热水，改小火慢炖', '改大火收汁，迅速翻炒使得每一块红烧肉身上都裹满了浓汁']
meat_todos.each { |todo_name| title1_home.todos.create(name: todo_name, project_id: project_home.id) }

title2_home = project_home.titles.create(name: '绿豆汤')
soup_todos = ['绿豆淘洗干净浸泡1小时', '再次点火煮开，熄火再焖20分钟', '等锅内的绿豆汤自然冷却后，放入冰箱冷藏']
soup_todos.each { |todo_name| title2_home.todos.create(name: todo_name, project_id: project_home.id) }


