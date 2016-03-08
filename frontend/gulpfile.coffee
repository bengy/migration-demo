# Use gulp as taskmanager
#
# *Author:* Dominique Rau [domi.rau@gmail.com](mailto:domi.rau@gmail.com)<br/>
# *Version:* 0.0.1





# BUILD
# ------------------------------

# Require
gulp         = require "gulp"
watch        = require "gulp-watch"
gutil        = require "gulp-util"
del          = require "del"



# Clean
gulp.task "clean", ->
	del(["../backend/public/www/**"], false)
	return



# Copy
gulp.task "copy", ->
	gulp.src ["www/**/*"]
		.pipe gulp.dest "../backend/public/www/"



# Watch for changes and redo tasks
gulp.task "w", ["build"], ->
	gulp.watch ["source/scripts/*.coffee", "source/directives/*.coffee", "source/index.coffee", "source/components/**/*.coffee"], ["coffee"]
	gulp.watch ["source/partials/*jade", "source/index.jade", "source/components/**/*.jade"], ["jade"]
	gulp.watch ["source/styles/*.styl", "source/components/**/*.styl"], ["stylus"]





# TASKS
# ------------------------------

gulp.task "build"  , ["copy"]
gulp.task "make"   , ["build"]
gulp.task "default", ["build"]
