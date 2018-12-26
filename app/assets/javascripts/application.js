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
    $('.tomato-time-input').val(tomatoTime)
    let shortBreakTime = $('#shortBreakTimeSelect').val()
    $('.short-break').attr('value', shortBreakTime)
    let longBreakTime = $('#longBreakTimeSelect').val()
    $('.long-break').attr('value', longBreakTime)

    $('#tomatoSettingModal').modal('hide')
  })

  // take a break, short break or long break
  $('.project-container-header-row').on('click', '.take-break', function() {
    let minutes = $(this).attr('value')
    showBreakTimer(minutes, function() {
      alert('finished')
    })
  })

  // cancel break timer
  $('.break-timer-cancel').on('click', function(){
    clearInterval(timerInterval);
    $('.timer-content').addClass('hide');
    $('.header-row-content').removeClass('hide');
    enableElementsWhenTomatoStop()
  });

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
      clearInterval(timerInterval)
      $('.header-row-content').removeClass('hide')
      $('.timer-content').addClass('hide')
      if (callback) { callback() }
    }
  }, 500)
}
