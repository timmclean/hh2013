module.exports = (grunt) ->
	grunt.initConfig {
		pkg: grunt.file.readJSON 'package.json'
		coffee: {
			all: {
				files: [{
					expand: true
					cwd: 'src'
					src: '**/*.coffee'
					dest: 'compiled'
					ext: '.js'
				}]
			}
		}
		copy: {
			all: {
				files: [
					{
						expand: true
						src: 'package.json'
						dest: 'compiled'
					}
					{
						expand: true
						cwd: 'src'
						src: '**/*.html'
						dest: 'compiled'
					}
				]
			}
		}
		clean: ['compiled']
	}

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-copy'

	grunt.registerTask 'default', [
		'clean'
		'build'
	]

	grunt.registerTask 'build', [
		'copy'
		'coffee'
	]
