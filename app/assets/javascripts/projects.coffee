# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  new PerfectScrollbar('.project-sidebar', {
    minScrollbarLength: 20,
    maxScrollbarLength: 80
  })

  # 项目侧边栏导航
  $('.project-sidebar').on 'click', 'a.project-list', (e)->
    e.preventDefault()
    projectId = $(this).attr('value')
    replaceProjectContent(projectId)
    # 适配小屏
    screenWidth = $(document).width()
    if screenWidth < 920
      $('.project-sidebar, .project-sidebar-header-row').hide()
      $('.project-container, .project-container-header-row, .to-project-sidebar-link').show()

  # add title
  $('.title-add').on 'click', (e) ->
    e.preventDefault()
    $(this).attr 'disabled', true
    $('.title-add-loading').show()
    $('.title-add-icon').hide()

    projectId = $('.project-container .project-content').attr('value')
    url = '/projects/' + projectId + '/titles'
    data = { title: {name: '默认标题'} }

    $.post url, data, (data) ->
      $('.project-body').append(data)
      $('.title-add-loading').hide()
      $('.title-add-icon').show()

  # edit title
  $('.project-container').on 'click', '.edit-title-button', ->
    # 移掉其它的编辑框
    $('form.edit_title').remove()
    $('.title-content').show()

    title_content = $(this).parent()
    url = $(this).attr 'url'
    $.get url, (data) ->
      title_content.hide().after(data)
      # 下面两段代码是让他自动激活, 并且光标移到最后
      val = $('#update-title-input').val()
      $('#update-title-input').focus().val('').val(val)

  # cancel create title
  $('.project-container').on 'click', '#cancel-create-title-button', ->
    $('form#new_title').remove()
    $('#new-title-button').attr 'disabled', false

  # cancel update title
  $('.project-container').on 'click', '#cancel-update-title-button', ->
    $('form.edit_title').remove()
    $('.title-content').show()

  # update title
  $('.project-container').on 'click', '#update-title-button', ->
    edit_title_form = $('form.edit_title')
    url = edit_title_form.attr 'action'
    title_id = $(this).val()
    $.ajax
      type: 'patch'
      url: url
      data: edit_title_form.serialize()
     .done (data) ->
       edit_title_form.remove()
       $('#title-content-' + title_id).find('.title-body').text(data.name)
       $('#title-content-' + title_id).show()

  # create title
  $('.project-container').on 'click', '#create-title-button', (e) ->
    e.preventDefault()
    new_title_form = $('form#new_title')
    url = new_title_form.attr 'action'
    $.post url, new_title_form.serialize(), (data) ->
      new_title_form.remove()
      $('#new-title-button').attr 'disabled', false
      $('.project-body').append(data)

  # delete title
  $('.project-container').on 'click', '.delete-title-button', ->
    if confirm('确定删除吗?')
      url = $(this).attr 'url'
      title_id = $(this).val()
      $.ajax
        url: url
        type: 'delete'
      .done ->
        $('#title-container-' + title_id).remove()

  # bind enter key for update title
  $('.project-container').on 'keypress', '#update-title-input', (e) ->
    if e.which == 13
      e.preventDefault()
      $('#update-title-button').click()

  # bind enter key for create title
  $('.project-container').on 'keypress', '#create-title-input', (e) ->
    if e.which == 13
      e.preventDefault()
      $('#create-title-button').click()


  # create todo
  $('.project-container').on 'click', '.create-todo-button', ->
    url = $(this).attr 'url'
    title_id = $(this).val()
    new_todo_form = $(this).parent()
    create_todo_input = $(this).siblings('.create-todo-input')

    $.post url, new_todo_form.serialize(), (data) ->
      $('#todo-content-' + title_id).append(data)
      create_todo_input.val('')

  # bind enter key for create todo
  $('.project-container').on 'keypress', '.create-todo-input', (e) ->
    if e.which == 13
      e.preventDefault()
      $(this).siblings('.create-todo-button').click()

  # delete todo
  $('.project-container').on 'click', '.delete-todo-button', ->
    if confirm('确定要删除吗')
      url = $(this).attr 'url'
      todo_id = $(this).val()

      $.ajax
        url: url
        type: 'delete'
      .done ->
        $('#todo-list-' + todo_id).remove()

  # edit todo
  $('.project-container').on 'click', '.edit-todo-button', ->
    # 先删除其它的edit todo form
    $('form.edit_todo').remove()
    $('.todo-list').show()

    url = $(this).attr 'url'
    todo_id = $(this).val()
    $.get url, (data) ->
      $('#todo-list-' + todo_id).hide().after(data)
      val = $('.update-todo-input').val()
      $('.update-todo-input').val('').focus().val(val)

  # cancel update todo button
  $('.project-container').on 'click', '#cancel-update-todo-button', ->
    todo_id = $(this).val()
    $('form.edit_todo').remove()
    $('#todo-list-' + todo_id).show()


  # update todo
  $('.project-container').on 'click', '#update-todo-button', ->
    todo_id = $(this).val()
    edit_todo_form = $('form.edit_todo')
    url = edit_todo_form.attr 'action'

    $.ajax
      url: url
      type: 'patch'
      data: edit_todo_form.serialize()
    .done (data) ->
      edit_todo_form.remove()
      $('#todo-list-' + todo_id).find('.todo-body').text(data['name'])
      $('#todo-list-' + todo_id).show()

  # bind enter key for update todo
  $('.project-container').on 'keypress', '.update-todo-input', (e) ->
    if (e.which == 13)
      e.preventDefault()
      $('#update-todo-button').click()

  # new category
  $('#new-category-button').on 'click', ->
    $(this).attr 'disabled', true
    url = $(this).attr 'url'
    $.get url, (data) ->
      $('.category-zone').append(data)
      $('#create-category-input').focus()

  # create category
  $('.category-zone').on 'click', '#create-category-button', (e) ->
    e.preventDefault()
    new_category_form = $('form#new_category')
    url = new_category_form.attr 'action'
    $.post url, new_category_form.serialize(), (data) ->
      new_category_form.remove()
      $('#new-category-button').attr 'disabled', false
      $('.category-zone').append(data)

  # cancel create category
  $('.category-zone').on 'click', '#cancel-create-category-button', ->
    $('form#new_category').remove()
    $('#new-category-button').attr 'disabled', false

  # edit category
  $('.category-zone').on 'click', '.edit-category-button', ->
    # 移掉其它的编辑框
    $('form.edit_category').remove()
    $('.category-content').show()

    category_id = $(this).val()
    category_content = $('#category-content-' + category_id)
    url = $(this).attr 'url'
    $.get url, (data) ->
      category_content.hide().after(data)
      # 下面两段代码是让他自动激活, 并且光标移到最后
      val = $('#update-category-input').val()
      $('#update-category-input').focus().val('').val(val)

  # cancel update category
  $('.category-zone').on 'click', '#cancel-update-category-button', ->
    $('form.edit_category').parent().remove()
    $('.category-content').show()

  # update category
  $('.category-zone').on 'click', '#update-category-button', ->
    edit_category_form = $('form.edit_category')
    url = edit_category_form.attr 'action'
    category_id = $(this).val()
    $.ajax
      type: 'patch'
      url: url
      data: edit_category_form.serialize()
     .done (data) ->
       edit_category_form.parent().remove()
       $('#category-content-' + category_id).find('.category-body').text(data.name)
       $('#category-content-' + category_id).show()

  # delete category
  $('.category-zone').on 'click', '.delete-category-button', ->
    if confirm('确定删除吗?')
      url = $(this).attr 'url'
      category_id = $(this).val()
      $.ajax
        url: url
        type: 'delete'
      .done ->
        $('#category-container-' + category_id).remove()

  # bind enter key for create category
  $('.category-zone').on 'keypress', '#create-category-input', (e) ->
    if e.which == 13
      e.preventDefault()
      $('#create-category-button').click()

  # bind enter key for update category
  $('.category-zone').on 'keypress', '#update-category-input', (e) ->
    if e.which == 13
      e.preventDefault()
      $('#update-category-button').click()

  # create project
  $('.category-zone').on 'click', '.create-project-button', ->
    url = $(this).attr 'url'
    category_id = $(this).val()
    new_project_form = $(this).parent()
    create_project_input = $(this).siblings('.create-project-input')

    $.post url, new_project_form.serialize(), (data) ->
      $('#side-project-content-' + category_id).append(data)
      create_project_input.val('')

  # bind enter key for create project
  $('.category-zone').on 'keypress', '.create-project-input', (e) ->
    if e.which == 13
      e.preventDefault()
      $(this).siblings('.create-project-button').click()

  # delete project
  $('.category-zone').on 'click', '.delete-project-button', ->
    if confirm('确定要删除吗')
      url = $(this).attr 'url'
      project_id = $(this).val()

      $.ajax
        url: url
        type: 'delete'
      .done ->
        $('#project-list-' + project_id).remove()

  # edit project
  $('.category-zone').on 'click', '.edit-project-button', ->
    # 先删除其它的edit project form
    $('form.edit_project').remove()
    $('.project-list').show()

    url = $(this).attr 'url'
    project_id = $(this).val()
    $.get url, (data) ->
      $('#project-list-' + project_id).hide().after(data)
      val = $('.update-project-input').val()
      $('.update-project-input').val('').focus().val(val)

  # cancel update project button
  $('.category-zone').on 'click', '#cancel-update-project-button', ->
    project_id = $(this).val()
    $('form.edit_project').remove()
    $('#project-list-' + project_id).show()

  # update project
  $('.category-zone').on 'click', '#update-project-button', ->
    project_id = $(this).val()
    edit_project_form = $('form.edit_project')
    url = edit_project_form.attr 'action'

    $.ajax
      url: url
      type: 'patch'
      data: edit_project_form.serialize()
    .done (data) ->
      edit_project_form.remove()
      $('#project-list-' + project_id).find('.project-name').text(data['name'])
      $('#project-list-' + project_id).show()

  # bind enter key for update project
  $('.category-zone').on 'keypress', '.update-project-input', (e) ->
    if (e.which == 13)
      e.preventDefault()
      $('#update-project-button').click()


  # start tomato timer
  $('.project-container').on 'click', '.tomato-start', ->
    $('.tomato-button').addClass('disabled')
    $(this).find('.tomato-button').removeClass('disabled').addClass('clicked')
    $('.project-container-header-row .title-add').hide()
    $('.tomato-timer').css('display', 'flex')
    todoId = $(this).attr('value')
    startTomatoTimer(todoId, 1)

  # cancel tomato timer
  $('.timer-cancel').on 'click', ->
    clearInterval tt
    afterTomatoCancel()

  # colapse sidebar
  $('.to-category-sidebar-link').on 'click', ->
    $('.project-sidebar, .project-sidebar-header-row').hide()
    $('.category-sidebar, .category-sidebar-header-row').show()

  $('.to-project-sidebar-link').on 'click', ->
    $('.project-sidebar, .project-sidebar-header-row').show()
    $('.project-container, .project-container-header-row').hide()

startTomatoTimer = (todoId, minutes) ->
  final_time = (new Date).getTime() + minutes * 60 * 1000
  window.tt = setInterval ->
    showTime(final_time, minutes, todoId)
  , 500

showTime = (final_time, minutes, todoId) ->
  now = (new Date).getTime()
  distance = final_time - now
  if distance >= 0
    minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)).toString().padStart(2, 0)
    seconds = Math.floor((distance % (1000 * 60)) / 1000).toString().padStart(2, 0)
    $('.timer-show > b').text(minutes + ':' + seconds)
  else
    clearInterval tt
    createTomato(minutes, todoId)

createTomato = (minutes, todoId) ->
  url = 'todos/' + todoId + '/tomatoes?minutes=' + minutes
  $.post url, (data) ->
    afterTomatoDone()

afterTomatoDone = ->
  todayTomato = parseInt($('#today-tomato-num').text(), 10) + 1
  $('#today-tomato-num').text(todayTomato)

  $('.tomato-timer-header-row').hide()
  $('.project-container-header-row').show()

  $('.tomato-button').removeClass('disabled').removeClass('clicked')

  # todoTotalTomato = $('#todo-'+ data['id'] + '-total-tomato')
  # todoTotalTomatoNum = parseInt(todoTotalTomato.text(), 10) + 1
  # todoTotalTomato.text(todoTotalTomatoNum)

  # todoTodayTomato = $('#todo-'+ data['id'] + '-today-tomato')
  # todoTodayTomatoNum = parseInt(todoTodayTomato.text(), 10) + 1
  # todoTodayTomato.text(todoTodayTomatoNum)

afterTomatoCancel = ->
  $('.tomato-timer').hide()
  $('.project-container-header-row .title-add').show()
  $('.tomato-button').removeClass('disabled').removeClass('clicked')
