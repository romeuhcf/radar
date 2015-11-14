function answer_message(chat_id, message){
  var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );
  $.ajaxSetup( {
    beforeSend: function ( xhr ) {
      xhr.setRequestHeader( 'X-CSRF-Token', token );
    }
  });

  $.post("/chat_rooms/"+ chat_id + '/answer',{message: message} , function(data){
  })  .done(function() {
    $(".chat-room-" + chat_id).fadeOut(1300, function() { $(this).remove(); });
  })
  .fail(function() {
    alert( "Falha ao enviar resposta" );
  });
  //.always(function() {
  //  chat_reload();
  //});
}

function chat_archive(chat_id){
  var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );
  $.ajaxSetup( {
    beforeSend: function ( xhr ) {
      xhr.setRequestHeader( 'X-CSRF-Token', token );
    }
  });

  $.post("/chat_rooms/"+ chat_id + '/archive', {}, function(data){
  })  .done(function() {
    $(".chat-room-" + chat_id).fadeOut(1300, function() { $(this).remove(); });
  })
  .fail(function() {
    alert( "Falha ao arquivar conversa" );
  });
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

function chat_reload(){
  $("#chat-rooms").load("/chat_rooms.html");
}
