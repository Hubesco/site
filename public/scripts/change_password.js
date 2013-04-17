require.config({
  paths: {
    jquery: 'http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min',
    require: 'lib/requirejs',
    parsley: 'lib/jquery/parsley'
  },
  shim: {
    'parsley': ['jquery']
  }
});

requirejs(

  ['jquery', 'parsley'],

  function ($) {
    $(function(){
      $('form').parsley();
    });
  }
);
