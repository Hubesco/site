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
    requirejs: {
      options: {
        mainConfigFile: 'public/scripts/lib/requirejs/configuration.js',
        optimize: 'uglify2',
        wrap: true,
        optimizeAllPluginResources: true,
        baseUrl: './public/scripts'
      },
      parsley: {
        options: {
          name: 'modules/parsley-module',
          //mainConfigFile: 'public/scripts/modules/parsley-module.js',
          //name: 'lib/requirejs/almond-0.2.5',
          //include: ['modules/parsley-module'],
          out: 'public/scripts/modules/parsley-module.min.js',
          paths: {
            jquery: 'empty:'
          }
        }
      }
    },
    less: {
      production: {
        files: {
          'public/css/style.css': 'public/css/style.less'
        },
        options: {
          yuicompress: true
        }
      }
    },
    watch: {
      options: {
        interrupt: false
      },
      less: {
        files: ['**/*.less'],
        tasks: ['less']
      }
    }
  });

  // Load tasks.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // Task definition.
  grunt.registerTask('default', ['jshint', 'less', 'requirejs']);

};