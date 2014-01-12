define ['crafty', 'conf', 'components', 'map', 'scenes'],
(Crafty, Conf, Comp, Map, Scenes) ->

  start = ->
    console.log 'Starting game...'
    Crafty.init Conf.width, Conf.height
    Crafty.background 'rgb(0, 43, 54)'
    Map.grid.x = 12
    Map.grid.y = 28
    Crafty.scene 'NewLevel'

  # Exports
  start: start
