/* gulpfile.js - https://github.com/wearefractal/gulp */

var gulp = require('gulp');
var coffee = require('gulp-coffee');
var watch = require('glob-watcher');

var path = require('path');
var fs = require('fs');

var srcCoffeeDir = './coffee/';
var destDir = './src/';

var gulpCoffee = function(coffeeFile) {



    // Mirror srcCoffeeDir dir structure to destDir
    var normSrc = path.normalize(__dirname + '/' + srcCoffeeDir + '/');

    var relativeDestPath = path.relative(normSrc, path.dirname(coffeeFile));
    var normDestPath = path.normalize(destDir + '/' + relativeDestPath + '/');


    gulp.task('coffee', function() {

        var lol = gulp.src(coffeeFile)
            .pipe(coffee({bare: true}))
            .pipe(gulp.dest(normDestPath));

    });


    fs.stat(normDestPath, function(err, stats) {

        if(stats && err) {
            console.log('(fs.stat) ' + err);
            return;
        }

        // Create intermediate dirs in destDir as needed
        if(!stats) {
            fs.mkdir(normDestPath, function(err) {

                if (err) {
                    console.log('(fs.mkdir) ' + err);
                    return;

                } else {

                    // Gulp some coffee
                    gulp.run('coffee');

                }
            });
            return;

        } else if(stats && stats.isDirectory()) {

            // Gulp some coffee
            gulp.run('coffee');
        

        } else {
            console.log(normDestPath + " is probably not a directory");
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