define ['crafty', 'map'], (Crafty, Map) ->
  level = 0

  Crafty.scene 'Game', ->
    console.log 'Change to Game scene'
    Map.init()
    enemy_spawner = Crafty.e 'EnemySpawner'
    enemy_spawner.set_spawn_factor (level - 1) * 0.3 + 1
  , ->
    Crafty('EnemySpawner').each -> @destroy()

  Crafty.scene 'Victory', ->
    console.log 'Change to Victory scene'
    Crafty.e 'VictoryScreen'


  Crafty.scene 'Defeat', ->
    console.log 'Change to Defeat scene'
    Crafty.e 'DefeatScreen'
    level = 0


  Crafty.scene 'NewLevel', ->
    console.log 'Change to New Level scene'
    level += 1
    console.log "Current level #{level}"
    Crafty.e('NewLevelScreen').newLevelScreen level
