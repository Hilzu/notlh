define ['crafty', 'conf', 'map', 'util'], (Crafty, Conf, Map, Util) ->
  Crafty.c 'Tile',
    init: ->
      @requires '2D, Canvas, Color'
      @attr w: Map.grid.tile_size, h: Map.grid.tile_size
      @color 'rgb(7, 54, 66)'

    at: (loc) ->
      if loc? and loc.x? and loc.y?
        pos = Map.tile_loc_to_pos loc
        @attr x: pos.x, y: pos.y
      else
        Map.pos_to_tile_loc(x: @x, y: @y)


  Crafty.c 'Barrier',
    init: ->
      @requires '2D, Canvas, Color, Solid'
      @color 'rgb(220, 50, 47)'

    size: (size) ->
      if size? and size.width? and size.height?
        @attr w: size.width, h: size.height
      else
        width: @w, height: @h


  Crafty.c 'PlayerCharacter',
    init: ->
      @requires 'Tile, Fourway, Collision'
      @color 'rgb(42, 161, 152)'
      @fourway 2
      @onHit 'Solid', @stop_movement
      @onHit 'GreatAncientOne', @meet_the_ancient
      @onHit 'TheEnemy', @die

    stop_movement: ->
      if @_movement
        @x -= @_movement.x
        @y -= @_movement.y

        @x += @_movement.x
        @x -= @_movement.x if @hit('Solid')

        @y += @_movement.y
        @y -= @_movement.y if @hit('Solid')

    meet_the_ancient: ->
      Crafty.scene 'NewLevel'

    die: ->
      Crafty.pause true
      Crafty.e('TitleText').titleText 'Dead!'
      @timeout(
        ->
          Crafty.pause false
          Crafty.scene 'Defeat'
        2000)


  Crafty.c 'GreatAncientOne',
    init: ->
      @requires 'Tile'
      @color 'rgb(211, 54, 130)'


  Crafty.c 'TheEnemy',
    init: ->
      @requires 'Tile, Enemy, Collision'
      @color 'rgb(108, 113, 196)'
      @bind 'EnterFrame', @move_

    move_: (data) ->
      time_step = data.dt
      @y += 0.1 * time_step
      @destroy() if @y > Conf.height


  Crafty.c 'EnemySpawner',
    init: ->
      @bind 'EnterFrame', @spawn_enemy_if_time

    time_since_last_spawn: 0
    time_for_next_spawn: Conf.start_spawn_rate_in_ms

    spawn_enemy_if_time: (data) ->
      @time_since_last_spawn += data.dt
      if @time_since_last_spawn >= @time_for_next_spawn
        @time_since_last_spawn = 0
        @spawn_enemy()

    spawn_enemy: ->
      enemy_x =
        Math.floor(Math.random() *
          (Map.grid.width * Map.grid.tile_size - Map.grid.tile_size) +
          Map.grid.x)
      enemy_y = -40
      new_enemy = Crafty.e('TheEnemy').attr x: enemy_x, y: enemy_y
      if new_enemy.hit 'TheEnemy'
        new_enemy.destroy()
        @spawn_enemy()

    set_spawn_factor: (factor) ->
      console.log "Setting current spawn factor to #{factor}"
      @time_for_next_spawn = Conf.start_spawn_rate_in_ms * (1 / factor)


  Crafty.c 'TitleText',
    init: ->
      @requires '2D, Canvas, Text'
      @textColor '#FDF6E3', 1
      @textFont size: '40px', weight: 'bold'
      @text 'Unset'
      @z = 1

    titleText: (text) ->
      @text text
      @attr Util.pos_to_center_entity @


  Crafty.c 'SubTitleText',
    init: ->
      @requires 'TitleText'
      @textFont size: '20px'

    subTitleText: (text) ->
      @text text
      @attr Util.pos_to_center_entity @
      @y += 50


  Crafty.c 'VictoryScreen',
    init: ->
      @requires '2D, Canvas, Color'
      @attr x: 0, y: 0, w: Conf.width, h: Conf.height
      @color 'rgb(0, 43, 54)'
      Crafty.e('TitleText').titleText 'You won the game!'


  Crafty.c 'NewLevelScreen',
    init: ->
      @requires '2D, Canvas, Color'
      @attr x: 0, y: 0, w: Conf.width, h: Conf.height
      @color 'rgb(0, 43, 54)'
      Crafty.e('TitleText').titleText 'Level'

      @timeout ->
        Crafty.scene 'Game'
      , 3000

    newLevelScreen: (level) ->
      Crafty.e('SubTitleText').subTitleText "#{level}"


  Crafty.c 'DefeatScreen',
    init: ->
      @requires '2D, Canvas, Color'
      @attr x: 0, y: 0, w: Conf.width, h: Conf.height
      @color 'rgb(0, 43, 54)'
      Crafty.e('TitleText').titleText 'You lost the game!'

      retry_button = Crafty.e('TextButton').textButton 'Retry', ->
        Crafty.scene 'NewLevel'
      retry_button_pos = Util.pos_to_center_entity retry_button
      retry_button_pos.y += 50
      retry_button.attr retry_button_pos


  Crafty.c 'TextButton',
    init: ->
      @requires '2D, Canvas, Text, Mouse'
      @textColor '#FDF6E3', 1
      @textFont size: '20px'
      @text 'Unset'
      @z = 1

    textButton: (text, onClick) ->
      @text text
      @bind 'Click', onClick
