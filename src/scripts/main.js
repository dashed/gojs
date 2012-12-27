requirejs.config({
baseUrl: "scripts",
urlArgs: "bust=" +  (new Date()).getTime()
});
require(['app'], function () {
});
