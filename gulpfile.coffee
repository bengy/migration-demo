# Use gulp as taskmanager
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1



# See:
# https://github.com/gulpjs/gulp/blob/master/docs/recipes/incremental-builds-with-concatenate.md





# BUILD
# ------------------------------

# Require
gulp         = require "gulp"
sourcemaps   = require "gulp-sourcemaps"
coffee       = require "gulp-coffee"
stylus       = require "gulp-stylus"
concat       = require "gulp-concat"
concatCoffee = require "gulp-concat-sourcemap"
watch        = require "gulp-watch"
gutil        = require "gulp-util"
jade         = require "gulp-jade"
livereload   = require 'gulp-livereload'
plumber      = require "gulp-plumber"
del          = require "del"
nib          = require "nib"
wait         = require "gulp-wait"
ts           = require 'gulp-typescript'
accord       = require "gulp-accord"
cached       = require "gulp-cached"



# Clean
gulp.task "clean", ->
	del(["build/**"], false)
	return




# Typescript
tsProject = ts.createProject({
	declaration:true
	noExternalResolve:true
	})

gulp.task "ts", ->
	tsResult = gulp.src "source/components/*/**.ts"
	.pipe ts tsProject
	tsResult.pipe gulp.dest "build/components"



# Complile coffee

gulp.task "coffee", ->
	gulp.src [
			"source/scripts/*.coffee"
			"source/directives/**/*coffee"
			"source/index.coffee"
		]
		.pipe cached "coffee-glob"
		.pipe plumber()
		.pipe sourcemaps.init()
		.pipe coffee bare:true
		.pipe sourcemaps.write()
		.pipe gulp.dest "./build/js/"
		.pipe wait(1500)
		.pipe livereload()

	gulp.src [
			"source/components/*/**.coffee"
		]
		.pipe cached "coffee-comp"
		.pipe plumber()
		.pipe sourcemaps.init()
		.pipe coffee bare:true
		.pipe sourcemaps.write()
		.pipe gulp.dest "build/components/"
		.pipe wait(1500)
		.pipe livereload()



# Concat js files
gulp.task "concat", ->
	gulp.src [
		"bower_components/jquery/dist/jquery.min.js"
		"bower_components/jquery-address/src/jquery.address.js"
		"bower_components/semantic/dist/semantic.js"
		"bower_components/lodash/lodash.js"
		"bower_components/angular/angular.js"
		"bower_components/angular-aria/angular-aria.min.js"
		"bower_components/angular-animate/angular-animate.min.js"
		"bower_components/angular-route/angular-route.min.js"
		"bower_components/angular-google-maps/dist/angular-google-maps.js"
		"bower_components/angular-sanitize/angular-sanitize.js"
		"bower_components/angular-ws/angular-ws.js"
		"bower_components/angular-ui-ace/ui-ace.js"
		"bower_components/bluebird/js/browser/bluebird.min.js"
		"bower_components/angular-bluebird-promises/dist/angular-bluebird-promises.min.js"
		"bower_components/ng-embed/dist/ng-embed.min.js"
		"bower_components/ngstorage/ngStorage.js"
		"bower_components/ngInfiniteScroll/build/ng-infinite-scroll.js"
		"bower_components/ace-builds/src/ace.js"
		"bower_components/ace-builds/src/mode-json.js"
		"bower_components/ace-builds/src/theme-twilight.js"
		"bower_components/ace-builds/src/worker-json.js"
		"bower_components/tiny-emitter/dist/tinyemitter.js"
		"bower_components/restangular/dist/restangular.js"
		"bower_components/angular-filter/dist/angular-filter.js"
		"bower_components/angular-material/angular-material.js",
		"bower_components/moment/moment.js"
		"bower_components/SiriWaveJS/siriwave9.js"
		"bower_components/jquery-scrollintoview/jquery.scrollintoview.min.js"
		"bower_components/Recorderjs/recorder.js"
		]
		.pipe plumber()
		.pipe concat "bower.js", newLine: " ;\n"
		.pipe gulp.dest "build/js/"

# Stylus
gulp.task "stylus", ->

	gulp.src "source/styles/**/*.styl"
		.pipe cached "styl-comp"
		.pipe plumber()
		.pipe stylus use:[nib()], errors:true
		.pipe gulp.dest "build/css/"
		.pipe livereload()

	gulp.src "source/components/**/*.styl"
		.pipe cached "styl-comp"
		.pipe plumber()
		.pipe stylus use:[nib()], errors:true
		#.pipe accord "stylus", use:[nib()], errors:true
		.pipe gulp.dest "build/components/"
		.pipe livereload()


# Jade
gulp.task "jade", ->
	gulp.src "source/partials/**.jade"
		.pipe cached "jade-partials"
		.pipe plumber()
		.pipe jade({pretty: true})
		.pipe wait(1500)
		.pipe gulp.dest "build/partials/"

	gulp.src "source/index.jade"
		.pipe cached "jade-index"
		.pipe plumber()
		.pipe jade()
		.pipe gulp.dest "build/"
		.pipe wait(1500)
		.pipe livereload()

	gulp.src "source/components/**/*jade"
		.pipe cached "jade-components"
		.pipe plumber()
		.pipe jade()
		.pipe gulp.dest "build/components/"

# Copy
gulp.task "copy", ->

	gulp.src(["bower_components/ace-builds/src/worker-json.js"]).pipe gulp.dest "build/"
	gulp.src(["bower_components/material-design-iconsets/iconsets/**"]).pipe gulp.dest "build/iconsets/"
	gulp.src(["source/images/*"]).pipe gulp.dest "build/images/"
	gulp.src [
		"bower_components/animate.css/animate.css",
		"bower_components/ng-embed/dist/ng-embed.min.css",
		"bower_components/angular-material/angular-material.min.css"
		]
		.pipe concat "bower.css", newLine: " ;\n"
		.pipe gulp.dest "build/css/"

	gulp.src [
		"bower_components/semantic/dist/themes/default/assets/images/*"
		"source/assets/images/**/*"]
		.pipe gulp.dest "build/images/"

	gulp.src [
		"bower_components/semantic/dist/themes/default/assets/fonts/*"
		"source/assets/fonts/*",
		"source/fonts/*"]
		.pipe gulp.dest "build/fonts/"


	gulp.src [
		"bower_components/jquery/dist/jquery.min.map",
		"bower_components/angular-animate/angular-animate.min.js.map"
		"bower_components/angular-bluebird-promises/dist/angular-bluebird-promises.min.js.map"
		"bower_components/angular-animate/angular-animate.js"
		"bower_components/angular-aria/angular-aria.min.js.map",
		"bower_components/SiriWaveJS/siriwave9.js"
		"bower_components/Recorderjs/recorderWorker.js"
		]
		.pipe gulp.dest "build/js/"




# Watch for changes and redo tasks
gulp.task "w", ["build"], ->
	livereload.listen()
	gulp.watch ["source/scripts/*.coffee", "source/index.coffee", "source/components/*/**.coffee"], ["coffee"]
	gulp.watch ["source/partials/*jade", "source/index.jade", "source/components/**/*.jade"], ["jade"]
	gulp.watch ["source/styles/*.styl", "source/components/**/*.styl"], ["stylus"]





# TASKS
# ------------------------------

gulp.task "make"   , ["build"]
gulp.task "build"  , ["coffee", "jade", "stylus", "concat", "copy"]
gulp.task "default", ["build"]
gulp.task "serve"
