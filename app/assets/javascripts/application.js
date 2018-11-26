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
//= require_tree .

$(function() {
  $('.flash-close').on('click', function() {
    $('.flash-container').hide();
  })

  // first load page will active inbox or pinned
  let categoryType = $('.project-sidebar-content').attr('category_type')
  if (categoryType == 'starred')  {
    $('.category-list.sidebar-starred').addClass('active')
    $('.project-add').hide()
  } else {
    $('.category-list.sidebar-inbox').addClass('active')
  }
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
