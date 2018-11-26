$(function(){
  // 自动隐藏滚动条
  /*
  new PerfectScrollbar('.project-sidebar', {
    minScrollbarLength: 20,
    maxScrollbarLength: 80
  })
  */

  // category侧边栏导航
  $('.category-sidebar').on('click', ".category-list:not('.active')", function(e) {
    e.preventDefault()
    $('.category-list').removeClass('active')
    $(this).addClass('active')
    $('.project-add').show()

    $('.project-content').remove()
    $('.title-add').hide()

    let categoryType = $(this).attr('category_type')
    if (['starred', 'done'].includes(categoryType)) {
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
      addSidebarProjectCount(categoryType, categoryId, 1)

      target.removeClass('clicked');
      $('.project-add-loading').hide();
      $('.project-add-icon').show();

      let projectId = $(data).attr('value')
      let url = 'projects/' + projectId
      $('.project-list').removeClass('active')
      $('#project-list-' + projectId).addClass('active')

      $.get(url, function(result) {
        $('.project-container').html(result);
        $('.title-add').show()
        $('.project-name').dblclick()
        $('.project-name-input').select()
      });

    })
  })

  // edit project name
  $('.project-container').on('dblclick', '.project-name', function() {
    $('.project-name').show();
    let target = $(this).hide();
    let projectOriginName = target.text();
    let projectNameInput = $('.project-name-input');
    target.after(projectNameInput.show()[0]);
    projectNameInput.focus().val('').val(projectOriginName);
  });

  // cancel edit project name, bind Esc key
  $('.project-container').on('keydown', '.project-name-input', function(e) {
    if(e.which == 27) {
      e.preventDefault();
      $('.project-name-input').hide();
      $('.project-name').show();
    }
  });

  // update project name, bind to enter key
  $('.project-container').on('keydown', '.project-name-input', function(e) {
    var target = $(this).parent();
    if(e.which == 13) {
      e.preventDefault();
      var projectEditName = $(this).val();
      //make sure input not empty
      if(projectEditName) {
        var url = target.attr('url');
        let projectId = target.attr('value')
        var data = {project: {name: projectEditName}};

        $.ajax({
          type: 'patch',
          url: url,
          data: data
        }).done(function(data) {
          $('.project-name-input').hide();
          target.find('.project-name').text(data.name).show();

          $('#project-list-' + projectId).find('.project-list-name').text(data.name)

        });

      } else {
        alert('输入不能为空');
      }
    }
  });

  // star project
  $('.project-sidebar').on('click', '.star-project', function(e) {
    e.preventDefault()
    let target = $(this)
    let url = target.attr('url')
    let projectId = target.attr('value')
    let projectList = $('#project-list-' + projectId)
    let starIcon = projectList.find('.project-star-icon')

    $.ajax({
      url: url,
      method: 'patch'
    }).success(function() {
      starIcon.removeClass('d-none')
      projectList.addClass('starred')
      addSidebarProjectCount('starred', '0', 1)
    })
  })

  // unstar project
  $('.project-sidebar').on('click', '.unstar-project', function(e) {
    e.preventDefault()
    let target = $(this)
    let url = target.attr('url')
    let projectId = target.attr('value')
    let projectList = $('#project-list-' + projectId)
    let starIcon = projectList.find('.project-star-icon')

    $.ajax({
      url: url,
      method: 'patch'
    }).success(function() {
      starIcon.addClass('d-none')
      projectList.removeClass('starred')
      addSidebarProjectCount('starred', '0', -1)
    })
  })

  // delete project
  $('.project-sidebar').on('click', '.delete-project', function(e) {
    e.preventDefault()
    $('#delete-project-modal').modal()
    let target = $(this)
    let url = target.attr('url')
    let projectId = target.attr('value')
    let projectList = $('#project-list-' + projectId)

    $('.delete-project-confirm').on('click', function() {
      $.ajax({
        url: url,
        method: 'delete'
      }).success(function() {
        $('#delete-project-modal').modal('hide')
        projectList.remove()
        $('.project-content').remove()
        let firstProject = $('.project-sidebar .project-list')[0]
        if (firstProject) {
          firstProject.click()
        }
        let categoryType = $('.project-sidebar-content').attr('category_type')
        let categoryId = $('.project-sidebar-content').attr('category_id')
        // 处理删除project后category侧边栏的计数问题
        switch (categoryType) {
          case 'starred':
            addSidebarProjectCount(categoryType, categoryId, -1)
            let originalCategoryId = target.attr('category_id')
            if (originalCategoryId) {
              addSidebarProjectCount('custom', originalCategoryId, -1)
            } else {
              addSidebarProjectCount('inbox', '0', -1)
            }
            break
          default:
            addSidebarProjectCount(categoryType, categoryId, -1)
            if (projectList.attr('class').includes('starred')) {
              addSidebarProjectCount('starred', '0', -1)
            }
        }
        // 处理完毕
      })
    })


  })

  // mark project done
  $('.project-sidebar').on('click', '.done-project', function(e) {
    e.preventDefault()
    let target = $(this)
    let projectId = target.attr('value')
    let url = '/projects/' + projectId + '/done'
    let projectList = $('#project-list-' + projectId)

    $.ajax({
      url: url,
      method: 'patch'
    }).success(function() {
      projectList.remove()
      $('.project-content').remove()
      let firstProject = $('.project-sidebar .project-list')[0]
      if (firstProject) {
        firstProject.click()
      }
      let categoryType = $('.project-sidebar-content').attr('category_type')
      let categoryId = $('.project-sidebar-content').attr('category_id')
      // 处理删除project后category侧边栏的计数问题
      switch (categoryType) {
        case 'starred':
          addSidebarProjectCount(categoryType, categoryId, -1)
          addSidebarProjectCount('done', '0', 1)
          let originalCategoryId = target.attr('category_id')
          if (originalCategoryId) {
            addSidebarProjectCount('custom', originalCategoryId, -1)
          } else {
            addSidebarProjectCount('inbox', '0', -1)
          }
          break
        default:
          addSidebarProjectCount(categoryType, categoryId, -1)
          addSidebarProjectCount('done', '0', 1)
      }
      // 处理完毕
    })
  })

  // undone project
  $('.project-sidebar').on('click', '.undone-project', function(e) {
    e.preventDefault()
    let target = $(this)
    let projectId = target.attr('value')
    let url = '/projects/' + projectId + '/undone'
    let projectList = $('#project-list-' + projectId)

    $.ajax({
      url: url,
      method: 'patch'
    }).success(function() {
      projectList.remove()
      $('.project-content').remove()
      let firstProject = $('.project-sidebar .project-list')[0]
      if (firstProject) {
        firstProject.click()
      }

      // 处理undone project后category侧边栏的计数问题
      addSidebarProjectCount('done', '0', -1)
      let originalCategoryId = target.attr('category_id')
      if (originalCategoryId) {
        addSidebarProjectCount('custom', originalCategoryId, 1)
      } else {
        addSidebarProjectCount('inbox', '0', 1)
      }
      // 处理完毕
    })
  })

  // create category
  $(".category-sidebar-header-row").on('click', ".category-add:not('.clicked')", function(e){
    e.preventDefault();
    var target = $(this).addClass('clicked');
    $('.category-add-loading').show();
    $('.category-add-icon').hide();

    let url = '/categories'
    let data = { category: {name: '默认category'} };

    $.post(url, data, function(data){
      $('.custom-category-zone').append(data)

      target.removeClass('clicked');
      $('.category-add-loading').hide();
      $('.category-add-icon').show();

      var viewElement = $('.custom-category-zone .category-list').last();
      viewElement[0].scrollIntoView();

      viewElement.find('.category-name').dblclick();
      $('.category-edit-input').select();
    })
  })

  // edit category
  $('.custom-category-zone').on('dblclick', '.category-name', function(e) {
    e.stopPropagation()
    $('.category-name').show();
    let target = $(this).hide();
    let categoryEditName = target.text();
    var categoryEditInput = $('.category-edit-input');
    target.after(categoryEditInput.show()[0]);
    categoryEditInput.focus().val('').val(categoryEditName);
  });

  // cancel edit category, bind Esc key
  $('.custom-category-zone').on('keydown', '.category-edit-input', function(e) {
    if(e.which == 27) {
      e.preventDefault();
      $('.category-edit-input').hide();
      $('.category-name').show();
    }
  });

  // update category, bind to enter key
  $('.custom-category-zone').on('keydown', '.category-edit-input', function(e) {
    var target = $(this).parent();
    let categoryId = target.attr('value')
    if(e.which == 13) {
      e.preventDefault();
      var categoryEditName = $(this).val();
      //make sure input not empty
      if(categoryEditName) {
        let url = '/categories/' + categoryId
        var data = {category: {name: categoryEditName}};

        $.ajax({
          type: 'patch',
          url: url,
          data: data
        }).done(function(data) {
          $('.category-edit-input').hide();
          target.find('.category-name').text(data.name).show();
        });

      } else {
        alert('输入不能为空');
      }
    }
  });

  // delete category
  $('.custom-category-zone').on('click', '.delete-category', function() {
    let categoryList = $(this).parent()
    let categoryId = categoryList.attr('value')
    $('#delete-category-modal').modal()
    $('.delete-category-confirm').on('click', function() {
      let url = '/categories/' + categoryId
      $.ajax({
        method: 'delete',
        url: url
      }).done(function(data) {
        $('#delete-category-modal').modal('hide')
        categoryList.remove()
        $('.project-sidebar-content').remove()
        $('.project-content').remove()

        $('.sidebar-inbox').click()
        addSidebarProjectCount('inbox', '0', data.undone_projects_count)
        addSidebarProjectCount('starred', '0', data.starred_projects_count)
      })
    })
  });

  // show save button when trix-change for project description
  addEventListener("trix-change", function(event) {
    $('.save-project-description').removeClass('d-none')
  })

  // save project description
  $('.project-container').on('click', '.save-project-description', function() {
    let projectId = $(this).parent().attr('value')
    let url = '/projects/' + projectId
    let description = $('#project-description-input').val()
    let data = { project: { description: description } }

    $.ajax({
      method: 'patch',
      url: url,
      data: data
    }).done(function() {
      $('.save-project-description').addClass('d-none')
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

// 给category侧边栏的某个category的project计数增加数目
function addSidebarProjectCount(categoryType, categoryId, count) {
  let sidebarCategory, projectCount
  if (categoryId === '0') {
    switch (categoryType) {
      case 'inbox':
        sidebarCategory = $('.sidebar-inbox .row-stat')
        break
      case 'starred':
        sidebarCategory = $('.sidebar-starred .row-stat')
        break
      case 'done':
        sidebarCategory = $('.sidebar-done .row-stat')
        break
    }
    projectCount = parseInt(sidebarCategory.text())
    sidebarCategory.text(projectCount + count)
    return
  }

  sidebarCategory = $('#category-list-' + categoryId + ' .row-stat')
  projectCount = parseInt(sidebarCategory.text())
  sidebarCategory.text(projectCount + count)
}


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


