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
		stylus: {
			all: {
				files: [{
					expand: true
					cwd: 'src'
					src: '**/*.styl'
					dest: 'compiled'
					ext: '.css'
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
						src: ['**/*.html', '**/*.js', '**/*.css']
						dest: 'compiled'
					}
				]
			}
		}
		clean: ['compiled']
		watch: {
			all: {
				files: ['src/**']
				tasks: ['clean', 'build']
			}
		}
	}

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-stylus'
	grunt.loadNpmTasks 'grunt-contrib-watch'

	grunt.registerTask 'default', [
		'clean'
		'build'
		'watch'
	]

	grunt.registerTask 'build', [
		'copy'
		'coffee'
		'stylus'
	]
