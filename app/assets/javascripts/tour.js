var tour = new Tour({
  name: 't323',
  backdrop: true,
  debug: true,
  steps: [
    {
    orphan: true,
    title: "Bem-vindo ao painel de controle",
    content: "Bem-vindo ao painel de controle! Posso te explicar como funciona essa tela?",
  },
  {
    element: ".sidebar",
    title: "Menu Geral",
    content: "Aqui você escolhe o que quer fazer"
  },
  {
    element: ".dashboard-stats",
    title: "Movimentação do dia",
    content: "Aqui você visualiza o que aconteceu no seu dia, consegue saber o quanto mandou, está agendado ou já teve sua entregua realizada ou falha"
  },

  ]});
  $(function(){
    // Initialize the tour

    // Start the tour
    setTimeout( function(){
      tour.init();
      tour.start();
    }, 1000);
  });
