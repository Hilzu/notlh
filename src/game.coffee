define ['crafty', 'components', 'map', 'scenes'], (Crafty, c, Map, Scenes) ->

  # Exported object
  start: ->
    console.log 'Starting game...'
    Crafty.init Map.width, Map.height
    Crafty.background 'rgb(87, 109, 20)'
    Crafty.scene 'Loading'
