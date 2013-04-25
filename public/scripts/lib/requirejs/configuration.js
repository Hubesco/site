var require = {
  baseUrl: '/scripts',
  paths: {
    jquery: '//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min',
    parsley: 'lib/jquery/parsley',
    common: 'modules/common'
  },
  shim: {
    'parsley': ['jquery']
  }
};