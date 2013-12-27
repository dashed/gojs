/* gulpfile.js - https://github.com/wearefractal/gulp */

var gulp = require('gulp');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');

var path = require('path');
var fs = require('fs');

var srcCoffeeDir = './coffee/';
var destDir = './src/';

// Emulate coffee -b -w -c -o ./src/ ./coffee
var gulpCoffee = function(coffeeFile) {

    // Mirror srcCoffeeDir dir structure to destDir
    var normSrc = path.normalize(__dirname + '/' + srcCoffeeDir + '/');

    var relativeDestPath = path.relative(normSrc, path.dirname(coffeeFile));
    var normDestPath = path.normalize(destDir + '/' + relativeDestPath + '/');


    gulp.task('coffee', function() {

        gulp.src(coffeeFile)
            .pipe(coffee({bare: true})
                .on('error', gutil.log))
                // Trigger system bell
                .on('error', gutil.beep)

            .pipe(gulp.dest(normDestPath)
                .on('end', function() {
                    gutil.log("Compiled '" + path.relative(__dirname, coffeeFile) + "'");
                }));

    });

    fs.stat(normDestPath, function(err, stats) {

        if(stats && err) {
            gutil.log('(fs.stat) ' + err) && gutil.beep();
            return;
        }

        // Create intermediate dirs in destDir as needed
        if(!stats) {
            fs.mkdir(normDestPath, function(err) {

                // Gulp some coffee or shout error
                err ? gutil.log('(fs.mkdir) ' + err) && gutil.beep() : gulp.run('coffee');

            });
            return;

        } else if(stats && stats.isDirectory()) {

            // Gulp some coffee
            gulp.run('coffee');
        

        } else {
            gutil.log(normDestPath + " is probably not a directory") && gutil.beep();
        }

    });
}

// The default task (called when you run `gulp`)
gulp.task('default', function() {

    // Watch coffeescript files and compile them if they change
    gulp.watch(srcCoffeeDir + '/**/*.coffee', function(event) {
        gulpCoffee(event.path);
    });

});

gulp.task('build', function() {

    // Future...
});

gulp.task('requirejs', function() {

    // Future...
});