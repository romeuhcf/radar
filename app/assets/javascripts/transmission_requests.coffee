# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/ 
jQuery ->
  $('form.edit_transmission_request').fileupload
    dataType: "script"
    add: (e, data) ->
      data.context = $(tmpl("template-upload", data.files[0])) 
      $('#batch-file').html(data.context)
      data.submit()
    progress: (e,data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10) 
        data.context.find('.progress-bar').css('width', progress+'%') 
    done: (e,data) ->
      link = $('a.next-step')
      link.removeClass('btn-default')
      link.addClass('btn-primary')
      link.attr('href', link.data('href'))
