define ->
  # source: http://stackoverflow.com/a/3885844/412627
  return (n) ->
    return (n is +n and n is (n | 0))