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
      $('.project-content .body').append(data)
      $('#create-title-input').focus()

  # edit title
  $('.project-container').on 'click', '.edit-title-button', ->
    # 移掉其它的编辑框
    $('form.edit_title').remove()
    $('.title-container').show()

    that = $(this)
    url = $(this).attr 'url'
    $.get url, (data) ->
      that.parent().hide().after(data)
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
    title_id = $(this).val()
    $('#title-container-' + title_id).show()

  # update title
  $('.project-container').on 'click', '#update-title-button', ->
    # alert 'hi'
    edit_title_form = $('form.edit_title')
    url = edit_title_form.attr 'action'
    title_id = $(this).val()
    $.ajax
      type: 'patch'
      url: url
      data: edit_title_form.serialize()
     .done (data) ->
       edit_title_form.remove()
       $('#title-container-' + title_id).replaceWith(data)

  # create title
  $('.project-container').on 'click', '#create-title-button', (e) ->
    e.preventDefault()
    new_title_form = $('form#new_title')
    url = new_title_form.attr 'action'
    $.post url, new_title_form.serialize(), (data) ->
      new_title_form.remove()
      $('#new-title-button').attr 'disabled', false
      $('.project-content .body').append(data)

  # delete title
  $('.project-container').on 'click', '.delete-title-button', ->
    if confirm('确定删除吗?')
      url = $(this).attr 'url'
      title_container = $(this).parent()
      $.ajax
        url: url
        type: 'delete'
      .done ->
        title_container.remove()

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


