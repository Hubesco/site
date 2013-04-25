define(

  ['jquery'],

  function ($) {
    $(function(){
      $('#menu').on('click', function (){
        $('#second').slideToggle();
      });
    });
  }

);