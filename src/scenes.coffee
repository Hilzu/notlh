define ['crafty', 'map'], (Crafty, Map) ->
  Crafty.scene 'Game', ->
    console.log 'Change to Game scene'
    Map.init()
    Crafty.e 'EnemySpawner'


  Crafty.scene 'Victory', ->
    console.log 'Change to Victory scene'
    Crafty.e 'VictoryScreen'


  Crafty.scene 'Defeat', ->
    console.log 'Change to Defeat scene'
    Crafty.e 'DefeatScreen'
