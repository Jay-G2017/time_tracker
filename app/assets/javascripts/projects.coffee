# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('a.project-link').on 'click', (e) ->
    e.preventDefault()
    project_id = $(this).attr 'id'

    url = '/projects/' + project_id
    $.get url, (data) ->
      $('.project-content').html data

  # new title
  $('.project-content').on 'click', '#new-title-button', (e) ->
    e.preventDefault()
    $(this).attr 'disabled', true
    url = $(this).attr 'url'
    $.get url, (data) ->
      $('.project-content .body').append(data)

  # edit title
  $('.project-content').on 'click', '.edit-title-button', ->
    # 移掉其它的编辑框
    $('form.edit_title').remove()
    $('.title-container').show()

    that = $(this)
    url = $(this).attr 'url'
    $.get url, (data) ->
      that.parent().hide().after(data)

  # cancel create title
  $('.project-content').on 'click', '#cancel-create-title-button', ->
    $('form#new_title').remove()
    $('#new-title-button').attr 'disabled', false

  # cancel update title
  $('.project-content').on 'click', '#cancel-update-title-button', ->
    $('form.edit_title').remove()
    title_id = $(this).val()
    $('#title-container-' + title_id).show()

  # update title
  $('.project-content').on 'click', '#update-title-button', ->
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
  $('.project-content').on 'click', '#create-title-button', (e) ->
    e.preventDefault()
    new_title_form = $('form#new_title')
    url = new_title_form.attr 'action'
    $.post url, new_title_form.serialize(), (data) ->
      new_title_form.remove()
      $('#new-title-button').attr 'disabled', false
      $('.project-content .body').append(data)

  # delete title
  $('.project-content').on 'click', '.delete-title-button', ->
    if confirm('确定删除吗?')
      url = $(this).attr 'url'
      title_container = $(this).parent()
      $.ajax
        url: url
        type: 'delete'
      .done ->
        title_container.remove()


