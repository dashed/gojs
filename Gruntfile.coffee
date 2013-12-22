# =================================
# do
#
# $ npm install
#
# Then...
# =================================
# $ grunt
# =================================

# Unsure if we really need this down the road.

module.exports = (grunt) ->
  grunt.initConfig
    build:
      all:
        dest: "dist/goban.js"

  grunt.registerTask 'default', 'build'