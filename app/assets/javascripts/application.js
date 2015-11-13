// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootbox
//= require bootstrap-sprockets
//= require_tree .
//
//
function answer_message(chat_id, message){
  var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );
  $.ajaxSetup( {
    beforeSend: function ( xhr ) {
      xhr.setRequestHeader( 'X-CSRF-Token', token );
    }
  });

  $.post("/chat_rooms/"+chat_id,{message: message} , function(data){
  })  .done(function() {
    alert( "Mensagem enviada com sucesso" );
    // TODO.. recarregar listagem
  })
  .fail(function() {
    alert( "Falha ao enviar resposta" );
  });
//  .always(function() {
//    alert( "finished" );
//  });
}

function chat_answer_box(chat_id){
  bootbox.prompt({
    title: "Enviar mensagem de resposta [" + chat_id + "]",
    size: 'large',
    className: 'bla',
    callback: function(result){
      if (!result){return ;}
      answer_message(chat_id, result);
    }
  })

}
