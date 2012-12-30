({
    mainConfigFile: "app.js",
    //exclude: ['main'],
    wrap: true,
    optimize: "uglify2",
    appDir: "../",
    baseUrl: "scripts",
    dir: "../../build",
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
    ]
})