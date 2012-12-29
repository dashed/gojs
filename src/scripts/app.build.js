({
    mainConfigFile: "app.js",
    optimize: "uglify2",
    appDir: "../",
    baseUrl: "scripts",
    dir: "../../build",
    paths: {
        //jquery: "empty:"
    },
    modules: [
        {
            name: "main"
        }
    ]
})