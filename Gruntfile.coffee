module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      compile_all:
        options:
          bare: true
        expand: true
        flatten: true
        src: ['src/**/*.coffee']
        dest: 'assets/js/'
        ext: '.js'

    coffeelint:
      src: ['src/**/*.coffee']

    watch:
      files: ['src/**/*.coffee']
      tasks: ['coffeelint', 'coffee']

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
