// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require fontawesome-5.4.1
//= require perfect-scrollbar-1.4
//= require trix
//= require_tree .

$(function() {
  window.isTakingBreak = false

  $('.flash-close').on('click', function() {
    $('.flash-container').hide();
  })

  // first load page will active inbox or pinned
  let categoryType = $('.project-sidebar-content').attr('category_type')
  if (categoryType == 'starred')  {
    $('.category-list.sidebar-starred').addClass('active')
    $('.project-add').addClass('disabled')
  } else {
    $('.category-list.sidebar-inbox').addClass('active')
  }

  // 激活蕃茄设置的modal
  $('#tomatoSettingButton').on('click', function() {
    $('#tomatoSettingModal').modal({
    })
  })

  // 保存蕃茄设置的结果
  $('body').on('click', '.tomato-setting-save', function(e) {
    e.preventDefault()
    let tomatoTime = $('#tomatoTimeSelect').val()
    $('#tomatoTimeInput').val(tomatoTime)
    let shortBreakTime = $('#shortBreakTimeSelect').val()
    $('.short-break').attr('value', shortBreakTime)
    let longBreakTime = $('#longBreakTimeSelect').val()
    $('.long-break').attr('value', longBreakTime)

    $('#tomatoSettingModal').modal('hide')
  })

  // take a break, short break or long break
  $('.project-container-header-row').on('click', '.take-break', function() {
    let target = $(this)
    let minutes = $(this).attr('value')
    showBreakTimer(minutes, function() {
      let lastTodoId = $('#todoIdInput').val()
      if (lastTodoId) {
        lastTodoName = $('#todo-list-' + lastTodoId).find('.todo-name').text()
        $('#lastTodoName').text(lastTodoName)
        $('#lastTodoIdInput').val(lastTodoId)
        $('#continueLastTodoModal').modal()
      } else {
        $('#breakFinishModal').modal()
      }
    })
  })

  // cancel break timer
  $('.break-timer-cancel').on('click', function(){
    $('#takeBreakAudio')[0].load()
    clearInterval(timerInterval);
    isTakingBreak = false
    $('.timer-content').addClass('hide');
    $('.header-row-content').removeClass('hide');
    enableElementsWhenTomatoStop()
  });

  // save tomato
  $('#saveTomatoButton').on('click', function(e) {
    e.preventDefault()
    let form = $('#tomatoFinishForm')
    let data = form.serialize()
    let todoId = $('form #todoIdInput').val()
    let url = '/todos/' + todoId + '/tomatoes'
    $.post(url, data, function() {
      // add today tomato count
      let todayTomato = $('#todayTomatoNum')
      let num = todayTomato.text()
      num = parseInt(num, 10) + 1
      todayTomato.text(num)
      // add todo tomato count
      let todoCount = $('#todo-' + todoId + '-tomato-count')
      let count = todoCount.text()
      count = parseInt(count, 10) + 1
      todoCount.text(count)
      if($('#takeBreakAfterTomato').prop('checked')) {
        $('.short-break').click()
      }
    }).always(function() {
      $('#tomatoFinishModal').modal('hide')
    })
  })

  // continue last todo
  $('#continueLastTodo').on('click', function() {
    let todoId = $('#lastTodoIdInput').val()
    let minutes = $('#tomatoTimeInput').val()
    showTomatoTimer(minutes, todoId, function() {
      $('#tomatoFinishModal').modal({backdrop: 'static'})
    })
    showTodoListTimer(minutes, todoId)
    disableElementsWhenTomatoStart()
    $('#continueLastTodoModal').modal('hide')
  })

  // 关闭tomatoFinishModal后，把输入框和勾选框置为初始
  $('#tomatoFinishModal').on('hidden.bs.modal', function() {
    $('.tomato-text').val('')
    $('#doneTodoAfterTomato').prop('checked', false)
  })

});

function replaceProjectContent(projectId) {
  if(projectId == undefined) {
    $('.project-container').empty();
  }else {
    var url = 'projects/' + projectId;
    $.get(url, function(data) {
      $('.project-container').html(data);
      $('.title-add').show()
    });
  }
}

function showMessage(data, timeout=3000) {
  $('.flash-content .body').text(data);
  $('.flash-content').addClass('alert-error');
  $('.flash-container').show();
  setTimeout(function() {
    $('.flash-container').slideUp();
  }, timeout);
}

function showBreakTimer(minutes, callback) {
  isTakingBreak = true
  $('#takeBreakAudio')[0].play()
  $('.header-row-content, .tomato-timer-content').addClass('hide')
  $('.break-timer-content').removeClass('hide')
  $('.timer-show > b').text(minutes.padStart(2, 0) + ': 00');

  let finalTime = (new Date).getTime() + minutes * 60 * 1000
  window.timerInterval = setInterval(function() {
    let now = (new Date).getTime()
    let remainedTime = finalTime - now
    if (remainedTime >= 0) {
      let minutes = Math.floor((remainedTime % (1000 * 60 * 60)) / (1000 * 60)).toString().padStart(2, 0);
      let seconds = Math.floor((remainedTime % (1000 * 60)) / 1000).toString().padStart(2, 0);
      $('.timer-show > b').text(minutes + ':' + seconds);
    } else {
      $('#timeFinishAudio')[0].play()
      clearInterval(timerInterval)
      isTakingBreak = false
      $('.header-row-content').removeClass('hide')
      $('.timer-content').addClass('hide')
      if (callback) { callback() }
    }
  }, 500)
}
