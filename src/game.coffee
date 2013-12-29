define ['crafty', 'components', 'map', 'scenes'], (Crafty, Comp, Map, Scenes) ->
  height = 712
  width = 600

  start = ->
    console.log 'Starting game...'
    Crafty.init width, height
    Crafty.background 'rgb(0, 43, 54)'
    Map.grid.x = 12
    Map.grid.y = 28
    Crafty.scene 'Game'

  # Exports
  height: height
  start: start
  width: width
