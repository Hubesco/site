module.exports = function (grunt) {

  'use strict';

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      files: [
        'Gruntfile.js'
      ],
      options: {
        browser: true,
        camelcase: true,
        curly: true,
        eqeqeq: true,
        forin: true,
        immed: true,
        indent: 2,
        latedef: true,
        newcap: true,
        noarg: true,
        noempty: true,
        quotmark: 'single',
        undef: true,
        unused: true,
        trailing: true,
        predef: [
          'module'
        ]
      }
    },
    uglify: {
      compress: {
        files: {
          'public/scripts/build/lib/requirejs/require.js': 'public/scripts/lib/requirejs/require.js',
          'public/scripts/build/html5shiv.js': 'public/scripts/html5shiv.js'
        }
      }
    },
    requirejs: {
      options: {
        mainConfigFile: 'public/scripts/lib/requirejs/configuration.js',
        optimize: 'uglify2',
        wrap: true,
        optimizeAllPluginResources: true,
        baseUrl: './public/scripts',
        include: 'lib/requirejs/configuration',
        paths: {
          jquery: 'empty:'
        }
      },
      password: {
        options: { name: 'pages/password', out: 'public/scripts/build/pages/password.js' }
      },
      login: {
        options: { name: 'pages/login', out: 'public/scripts/build/pages/login.js' }
      },
      index: {
        options: { name: 'pages/index', out: 'public/scripts/build/pages/index.js' }
      },
      about: {
        options: { name: 'pages/about', out: 'public/scripts/build/pages/about.js' }
      },
      pricing: {
        options: { name: 'pages/pricing', out: 'public/scripts/build/pages/pricing.js' }
      },
      test: {
        options: { name: 'pages/test', out: 'public/scripts/build/pages/test.js' }
      }
    },
    less: {
      production: {
        files: {
          'public/css/style.css': 'public/css/style.less',
          'public/css/prism.css': 'public/css/prism.less'
        },
        options: {
          yuicompress: true
        }
      },
      dev: {
        files: { 'public/css/style.css': 'public/css/style.less' }
      }
    },
    watch: {
      options: {
        interrupt: false
      },
      less: {
        files: ['**/*.less'],
        tasks: ['less']
      },
      require: {
        files: ['**/*.js'],
        tasks: ['clean', 'requirejs']
      }
    },
    clean: ['public/scripts/build']
  });

  // Load tasks.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // Task definition.
  grunt.registerTask('default', ['jshint', 'clean', 'less:production', 'uglify', 'requirejs']);
  grunt.registerTask('travis', ['jshint', 'clean', 'less:production', 'uglify', 'requirejs']);

};