({
    mainConfigFile: "app.js",
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

    baseUrl: ".",
    optimize: "none",
    wrap: true,
    paths: {
        //jquery: "empty:"
        requireLib: 'require'
    },
    name: "gojs",
    include: ["requireLib", "main"],
    create: true,
    out: "../dist/gojs.js"

})