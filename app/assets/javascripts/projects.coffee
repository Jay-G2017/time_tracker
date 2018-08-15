# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('a.project-link').on 'click', (e) ->
    e.preventDefault()
    project_id = $(this).attr 'id'

    url = '/projects/' + project_id
    $.get url, (data) ->
      $('.project-content').remove()
      $('.project-container').append data

  # new title
  $('.project-container').on 'click', '#new-title-button', (e) ->
    e.preventDefault()
    $(this).attr 'disabled', true
    url = $(this).attr 'url'
    $.get url, (data) ->
      $('.project-body').append(data)
      $('#create-title-input').focus()

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

  # start tomato timer
  $('.start-tomato-button').on 'click', ->
    $('#cancel-tomato-button').show()
    $(this).hide().after("<div id= 'todo-timer' class='timer-show'>25:00</div>")
    url = $(this).attr('url')
    startTomatoTimer(1, url)

  # cancel tomato timer
  $('#cancel-tomato-button').on 'click', ->
    clearInterval tt
    $(this).hide()
    $('.start-tomato-button').show()
    $('#todo-timer').remove()
    $('.timer-show').text('25:00')

startTomatoTimer = (minutes, url) ->
  final_time = (new Date).getTime() + minutes * 60 * 1000
  window.tt = setInterval ->
    showTime(final_time, minutes, url)
  , 500

showTime = (final_time, minutes, url) ->
  now = (new Date).getTime()
  distance = final_time - now
  if distance >= 0
    minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)).toString().padStart(2, 0)
    seconds = Math.floor((distance % (1000 * 60)) / 1000).toString().padStart(2, 0)
    $('.timer-show').text(minutes + ':' + seconds)
  else
    clearInterval tt
    createTomato(minutes, url)

createTomato = (minutes, url) ->
  url = url + '?minutes=' + minutes
  $.post url, ->
    alert 'success'

