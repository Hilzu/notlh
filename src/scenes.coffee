define ['crafty', 'map'], (Crafty, Map) ->
  Crafty.scene 'Game', ->
    console.log 'Change to Game scene'
    Map.init()


  Crafty.scene 'Victory', ->
    console.log 'Change to Victory scene'
    Crafty.e 'VictoryScreen'
