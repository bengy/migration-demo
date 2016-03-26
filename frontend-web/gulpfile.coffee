# Use gulp as taskmanager
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1-alpha.0





# Dependencies
# ------------------------------
gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
stylus     = require 'gulp-stylus'
jade       = require 'gulp-jade'
concat     = require 'gulp-concat'
livereload = require 'gulp-livereload'
watch      = require 'gulp-watch'
del        = require 'del'
nib        = require 'nib'
plumber    = require 'gulp-plumber'
flatten    = require 'gulp-flatten'
_          = require 'lodash'





# Complile coffee
# ------------------------------
gulp.task 'coffee', ->
	gulp.src [
			'src/index.coffee'
			'src/**/*.coffee']
		.pipe plumber()
		.pipe concat 'app.coffee'
		.pipe coffee bare:true
		.pipe gulp.dest 'dist/js/'
		.pipe livereload()





# Concat
# ------------------------------
gulp.task 'concat', ->

	# JS files
	gulp.src [
		'bower_components/jquery/dist/jquery.min.js'
		'bower_components/angular/angular.min.js'
		'bower_components/angular-sanitize/angular-sanitize.min.js'
		'bower_components/angular-route/angular-route.min.js'
		'bower_components/angular-cookies/angular-cookies.min.js'
		'bower_components/angular-aria/angular-aria.min.js'
		'bower_components/angular-animate/angular-animate.min.js'
		'bower_components/angular-messages/angular-messages.min.js'
		"bower_components/angular-material/angular-material.min.js"
		'bower_components/angular-translate/angular-translate.min.js'
		]
		.pipe concat 'bower.js', newLine: ';\n'
		.pipe gulp.dest 'dist/js/'

	# CSS files
	gulp.src ['bower_components/angular-material/angular-material.min.css']
		.pipe concat 'bower.css', newLine: '\n'
		.pipe gulp.dest 'dist/css/'





# Stylus
# ------------------------------
gulp.task 'stylus', ->
	gulp.src 'src/**/*.styl'
		.pipe plumber()
		.pipe stylus use:[nib()], errors:true
		.pipe concat 'dist.css'
		.pipe gulp.dest 'dist/css/'
		.pipe livereload()





# Jade
# ------------------------------
gulp.task 'jade', ->
	gulp.src 'src/index.jade'
		.pipe plumber()
		.pipe jade()
		.pipe gulp.dest 'dist'
		.pipe livereload()
	gulp.src 'src/views/**/*.jade'
		.pipe plumber()
		.pipe jade()
		.pipe gulp.dest 'dist/views'
		.pipe livereload()





# Copy
# ------------------------------
gulp.task 'copy', ->
	gulp.src(['bower_components/**/*.min.js.map']).pipe(flatten()).pipe gulp.dest 'dist/js/'
	gulp.src(['src/images/**/*']).pipe(flatten()).pipe gulp.dest 'dist/img/'





# Watch for changes and redo tasks
# ------------------------------
gulp.task 'w', ['build'], ->
	livereload.listen()
	watch 'src/**/*.coffee', -> gulp.start 'coffee'
	watch 'src/**/*.jade', -> gulp.start 'jade'
	watch 'src/**/*.styl', -> gulp.start 'stylus'
	watch 'src/images/**/*', -> gulp.start 'copy'





# Clean
# ------------------------------
gulp.task 'clean', ->
	del(['dist/**/*'], false)
	return





# Deploy
# ------------------------------
gulp.task "deploy", ["build"], ->
	gulp.src(["dist/**/*"]).pipe gulp.dest "../backend/public/www/"

gulp.task "deploy-clean", ->
	del(["../backend/public/www/**"], {force: true})





# Task list
# ------------------------------
gulp.task 'release', ['build']
gulp.task 'make', ['build']
gulp.task 'build', ['coffee', 'jade', 'stylus', 'concat', 'copy']
gulp.task 'default', ['build']
