requirejs(

  ['jquery', 'parsley'],

  function ($) {
    $(function(){
      $('form').parsley();
    });
  }

);
