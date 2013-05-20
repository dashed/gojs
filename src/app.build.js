({
    mainConfigFile: "main.js",
    //exclude: ['main'],
    /*skipDirOptimize: true,
    wrap: true,
    optimize: "uglify2",
    appDir: "../",
    baseUrl: "src",
    dir: "../build",
    paths: {
        //jquery: "empty:"
        requireLib: 'require'
    },

    // see: http://requirejs.org/docs/faq-advanced.html
    modules: [
        {
            name: "gojs",
            include: ["requireLib", "main"],
            create: true
        }
    ]*/

    // baseUrl: ".",
    // optimize: "uglify2",
    // wrap: true,
    // paths: {
    //     //jquery: "empty:"
    //     requireLib: 'require'
    // },
    // name: "gojs",
    // include: ["requireLib", "main"],
    // create: true,
    // out: "../dist/gojs_old_optimized.js"

    optimize: "uglify2",
    baseUrl: '.',
    name: './almond',
    include: ['main'],
    insertRequire: ['main'],
    out: "../dist/gojs.js",
    wrap: true

})