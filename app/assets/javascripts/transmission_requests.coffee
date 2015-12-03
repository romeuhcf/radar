# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/ 
upload_iface_canceled = ->
  $('#transmission_request_batch_file').show()
  $('#batch-file').html('')
  
  link = $('a.next-step')
  link.addClass('btn-default')
  link.removeClass('btn-primary')
  link.attr('href', '#') 
 

jQuery ->
  $('form.edit_transmission_request').fileupload
    dataType: "script"
    add: (e, data) ->
      if !/\.(csv|tsv)$/i.test(data.files[0].name)
        alert("Tipo de arquivo inválido")
        return 
      data.context = $(tmpl("template-upload", data.files[0])) 
      $('#batch-file').html(data.context)
      $('#transmission_request_batch_file').hide()
      jqXHR = data.submit()
      $('#upload-cancel').on 'click', (e) ->
        $(this).html('Cancelando...')
        jqXHR.abort()
        return
    progress: (e,data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10) 
        data.context.find('.progress-bar').css('width', progress+'%') 
    done: (e,data) ->
      link = $('a.next-step')
      link.removeClass('btn-default')
      link.addClass('btn-primary')
      link.attr('href', link.data('href')) 

      $('#transmission_request_batch_file').show()
    fail: (e,data) ->
      upload_iface_canceled

      if (data.errorThrown != 'abort')
        alert("Erro importando arquivo: " + data.errorThrown)

