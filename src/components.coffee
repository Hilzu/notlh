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
      Crafty.scene 'Victory'

    die: ->
      Crafty.scene 'Defeat'


  Crafty.c 'GreatAncientOne',
    init: ->
      @requires 'Tile'
      @color 'rgb(211, 54, 130)'


  Crafty.c 'TheEnemy',
    init: ->
      @requires 'Tile, Enemy'
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

    spawn_enemy_if_time: (data) ->
      @time_since_last_spawn += data.dt
      if @time_since_last_spawn >= Conf.enemy_spawn_rate_in_ms
        @time_since_last_spawn = 0
        @spawn_enemy()

    spawn_enemy: ->
      enemy_x =
        Math.floor(Math.random() *
          (Map.grid.width * Map.grid.tile_size - Map.grid.tile_size) +
          Map.grid.x)
      enemy_y = -40
      Crafty.e('TheEnemy').attr x: enemy_x, y: enemy_y


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


  Crafty.c 'VictoryScreen',
    init: ->
      @requires '2D, Canvas, Color'
      @attr x: 0, y: 0, w: Conf.width, h: Conf.height
      @color 'rgb(0, 43, 54)'
      Crafty.e('TitleText').titleText 'You won the game!'


  Crafty.c 'DefeatScreen',
    init: ->
      @requires '2D, Canvas, Color'
      @attr x: 0, y: 0, w: Conf.width, h: Conf.height
      @color 'rgb(0, 43, 54)'
      Crafty.e('TitleText').titleText 'You lost the game!'
