$(function(){
  // 自动隐藏滚动条
  new PerfectScrollbar('.project-sidebar', {
    minScrollbarLength: 20,
    maxScrollbarLength: 80
  })

  // category侧边栏导航
  $('.category-sidebar').on('click', ".category-list:not('.active')", function(e) {
    e.preventDefault()
    $('.category-list').removeClass('active')
    $(this).addClass('active')
    $('.project-add').show()

    $('.project-content').remove()
    $('.title-add').hide()

    let categoryType = $(this).attr('category_type')
    if (['pinned', 'done'].includes(categoryType)) {
      $('.project-add').hide()
    }

    let url = $(this).attr('url')
    $.get(url, function(data) {
      $('.project-sidebar').html(data)
    })

  })

  // project侧边栏导航
  $('.project-sidebar').on('click', '.project-list', function(e) {
    e.preventDefault();

    $('.project-list').removeClass('active')
    $(this).addClass('active')

    var projectId = $(this).attr('value');
    replaceProjectContent(projectId);

    // 适配小屏
    var screenWidth = $(document).width();
    if (screenWidth < 920) {
      $('.project-sidebar, .project-sidebar-header-row').hide();
      $('.project-container, .project-container-header-row, .to-project-sidebar-link').show();
    }
  });

  // add title
  $(".project-container-header-row").on('click', ".title-add:not('.clicked')", function(e){
    e.preventDefault();
    var target = $(this).addClass('clicked');
    $('.title-add-loading').show();
    $('.title-add-icon').hide();

    var projectId = $('.project-container .project-content').attr('value');
    var url = '/projects/' + projectId + '/titles';
    var data = { title: {name: '默认标题'} };

    $.post(url, data, function(data){
      $('.project-body').append(data);
      target.removeClass('clicked');
      $('.title-add-loading').hide();
      $('.title-add-icon').show();


      var viewElement = $('.title-container').last();
      viewElement[0].scrollIntoView();

      viewElement.find('.title-name').dblclick();
      $('.title-edit-input').select();
    });

  });

  // edit title
  $('.project-container').on('dblclick', '.title-name', function() {
    $('.title-name').show();
    var target = $(this).hide();
    var titleEditName = target.text();
    var titleEditInput = $('.title-edit-input');
    target.after(titleEditInput.show()[0]);
    titleEditInput.focus().val('').val(titleEditName);
  });

  // cancel edit title, bind Esc key
  $('.project-container').on('keydown', '.title-edit-input', function(e) {
    if(e.which == 27) {
      e.preventDefault();
      $('.title-edit-input').hide();
      $('.title-name').show();
    }
  });

  // update title, bind to enter key
  $('.project-container').on('keydown', '.title-edit-input', function(e) {
    var target = $(this).parent();
    if(e.which == 13) {
      e.preventDefault();
      var titleEditName = $(this).val();
      //make sure input not empty
      if(titleEditName) {
        var url = target.attr('url');
        var data = {title: {name: titleEditName}};

        $.ajax({
          type: 'patch',
          url: url,
          data: data
        }).done(function(data) {
          $('.title-edit-input').hide();
          target.find('.title-name').text(data.name).show();
        });

      } else {
        alert('输入不能为空');
      }
    }
  });

  // start tomato timer
  $('.project-container').on('click', '.tomato-start', function() {
    $('.tomato-button').addClass('disabled');
    $(this).find('.tomato-button').removeClass('disabled').addClass('clicked');
    $('.project-container-header-row .title-add').hide();
    $('.tomato-timer').css('display', 'flex');
    var todoId = $(this).attr('value');
    startTomatoTimer(todoId, 1);
  });

  // cancel tomato timer
  $('.timer-cancel').on('click', function(){
    clearInterval(tt);
    afterTomatoCancel();
  });

  // delete title
  $('.project-container').on('click', '.title-delete', function() {
    if(confirm('Are you sure')) {
      var titleId = $(this).attr('value');
      var url = $(this).attr('url');
      $.ajax({
        method: 'delete',
        url: url
      }).done(function() {
        $('#title-container-' + titleId).slideUp();
      }).error(function(data) {
        showMessage(data.responseText);
      });
    }
  });

  // toggle title todos
  $('.project-container').on('click', '.toggle-title-todos', function() {
    $(this).find('svg').toggle();
    var titleId = $(this).attr('value');
    $('#title-todos-container-' + titleId).slideToggle();
  })

  // create todo
  $('.project-container').on('click', '.todo-add', function() {
    var url = $(this).attr('url');
    var titleId = $(this).attr('value');
    var data = { todo: {name: '默认名字'} };

    $.post(url, data, function(data) {
      $('#title-todos-container-' + titleId).append(data);

      var todoId = $(data).find('.todo-delete').attr('value');
      $('#todo-list-' + todoId).find('.todo-name').dblclick();
      $('.todo-edit-input').select();

      // hide title delete icon.
      var titleContainer = $('#title-container-' + titleId);
      titleContainer.find('.title-delete').hide();
      titleContainer.find('.toggle-title-todos').show();
    });
  });

  // edit todo
  $('.project-container').on('dblclick', '.todo-name', function() {
    $('.todo-name').show();
    var target = $(this).hide();
    var todoEditName = target.text();
    var todoEditInput = $('.todo-edit-input');
    target.after(todoEditInput.show()[0]);
    todoEditInput.focus().val('').val(todoEditName);
  });

  // cancel edit todo, bind Esc key
  $('.project-container').on('keydown', '.todo-edit-input', function(e) {
    if(e.which == 27) {
      e.preventDefault();
      $('.todo-edit-input').hide();
      $('.todo-name').show();
    }
  });


  // update todo, bind to enter key
  $('.project-container').on('keydown', '.todo-edit-input', function(e) {
    var target = $(this).parent();
    if(e.which == 13) {
      e.preventDefault();
      var todoEditName = $(this).val();
      //make sure input not empty
      if(todoEditName) {
        var url = target.attr('url');
        var data = {todo: {name: todoEditName}};

        $.ajax({
          type: 'patch',
          url: url,
          data: data
        }).done(function(data) {
          $('.todo-edit-input').hide();
          target.find('.todo-name').text(data.name).show();
        });

      } else {
        alert('输入不能为空');
      }
    }
  });

  // delete todo
  $('.project-container').on('click', '.todo-delete', function() {
    if(confirm('Are you sure')) {
      var todoId = $(this).attr('value');
      var titleId = $(this).attr('title_id');
      var url = $(this).attr('url');
      $.ajax({
        method: 'delete',
        url: url
      }).done(function() {
        $('#todo-list-' + todoId).slideUp();

        // show title delete icon when no todo exists.
        var titleContainer = $('#title-container-' + titleId);
        // <=1 is because slideUp tasks time to hide;
        if(titleContainer.find('.todo-list:visible').length <= 1) {
          titleContainer.find('.title-delete').show();
          titleContainer.find('.toggle-title-todos').hide();
        }
      }).error(function(data) {
        showMessage(data.responseText);
      });
    }
  });

  // create project
  $(".project-sidebar-header-row").on('click', ".project-add:not('.clicked')", function(e){
    e.preventDefault();
    var target = $(this).addClass('clicked');
    $('.project-add-loading').show();
    $('.project-add-icon').hide();

    let categoryId = $('.project-sidebar-content').attr('category_id')
    let categoryType = $('.project-sidebar-content').attr('category_type')
    let url = '/categories/' + categoryId + '/projects?category_id=' + categoryId + '&category_type=' + categoryType
    let data = { project: {name: '默认project'} };

    $.post(url, data, function(data){
      $('.project-sidebar-content').prepend(data)

      target.removeClass('clicked');
      $('.project-add-loading').hide();
      $('.project-add-icon').show();
    })
  })


});

function startTomatoTimer(todoId, minutes) {
  var finalTime = (new Date).getTime() + minutes * 60 * 1000;
  window.tt = setInterval(function(){
    showTime(finalTime, minutes, todoId);}
    , 500);
}


function showTime(finalTime, minutes, todoId) {
  var now = (new Date).getTime();
  var distance = finalTime - now;
  if (distance >= 0) {
    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)).toString().padStart(2, 0);
    var seconds = Math.floor((distance % (1000 * 60)) / 1000).toString().padStart(2, 0);
    $('.timer-show > b').text(minutes + ':' + seconds);
  } else {
    clearInterval(tt);
    //createTomato(minutes, todoId);
  }
}

function afterTomatoCancel() {
  $('.tomato-timer').hide();
  $('.project-container-header-row .title-add').show();
  $('.tomato-button').removeClass('disabled').removeClass('clicked');
}



/*
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

  */






  /*
  # colapse sidebar
  $('.to-category-sidebar-link').on 'click', ->
    $('.project-sidebar, .project-sidebar-header-row').hide()
    $('.category-sidebar, .category-sidebar-header-row').show()

  $('.to-project-sidebar-link').on 'click', ->
    $('.project-sidebar, .project-sidebar-header-row').show()
    $('.project-container, .project-container-header-row').hide()
  */

/*
*/


/*
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
  */


