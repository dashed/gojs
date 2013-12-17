({
    mainConfigFile: "main.js",
    optimize: "uglify2",
    baseUrl: '.',
    name: './almond',
    include: ['main'],
    insertRequire: ['main'],
    out: "../dist/gojs.js",
    wrap: true,
})