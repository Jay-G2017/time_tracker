# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # 分类侧边栏导航-自定义
  $('.category-sidebar').on 'click', '.custom-category-zone > a', (e)->
      e.preventDefault()
      categoryId = $(this).attr('value')
      url = $(this).attr('href')

      $.get url, (data) ->
        $('.project-sidebar').html data
        projectId = $('.project-sidebar > a').first().attr('value')
        replaceProjectContent(projectId)
        # 适配小屏
        screenWidth = $(document).width()
        if screenWidth < 920
          $('.category-sidebar, .category-sidebar-header-row').hide()
          $('.project-sidebar, .project-sidebar-header-row').show()
