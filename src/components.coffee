define ['crafty', 'conf', 'map', 'util'], (Crafty, Conf, Map, Util) ->
  Crafty.c 'Tile',
    init: ->
      @requires '2D, Canvas, Color'
      @attr w: Map.grid.tile_size, h: Map.grid.tile_size
      @color 'rgb(7, 54, 66)'

    # Move to given location or return current location if location not given
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

    # Set size or return current size if size not given
    size: (size) ->
      if size? and size.width? and size.height?
        @attr w: size.width, h: size.height
      else
        width: @_w, height: @_h


  Crafty.c 'PlayerCharacter',
    focused: false

    init: ->
      @requires 'Tile, Fourway, Collision, Keyboard'
      @color 'rgb(42, 161, 152)'
      @fourway Conf.player_speed
      @onHit 'Solid', @stop_movement
      @onHit 'GreatAncientOne', @meet_the_ancient
      @onHit 'TheEnemy', @die
      @bind 'KeyDown', @key_down
      @bind 'KeyUp', @key_up

    stop_movement: ->
      if @_movement
        @y -= @_movement.y

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
        Conf.death_screen_timeout)

    key_down: ->
      if @isDown('SHIFT') and not @focused
        @focused = true
        @change_speed Conf.player_speed * Conf.player_focus_speed_factor

    key_up: ->
      if not @isDown('SHIFT') and @focused
        @focused = false
        @change_speed Conf.player_speed

    change_speed: (new_speed) ->
      @speed x: new_speed, y: new_speed
      # Change current movement according to new speed
      @_movement.x = Math.sign(@_movement.x) * new_speed
      @_movement.y = Math.sign(@_movement.y) * new_speed


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
      @y += Conf.enemy_speed * data.dt
      @destroy() if @_y > Conf.height


  Crafty.c 'EnemySpawner',
    time_for_next_spawn: Conf.start_spawn_rate_in_ms
    time_since_last_spawn: 0

    init: ->
      @bind 'EnterFrame', @spawn_enemy_if_time

    spawn_enemy_if_time: (data) ->
      @time_since_last_spawn += data.dt
      if @time_since_last_spawn >= @time_for_next_spawn
        @time_since_last_spawn = 0
        @spawn_enemy()

    spawn_enemy: ->
      enemy_x = Math.floor(Math.random() *
        (Map.grid.width * Map.grid.tile_size - Map.grid.tile_size) + Map.grid.x)
      enemy_y = -40
      new_enemy = Crafty.e('TheEnemy').attr x: enemy_x, y: enemy_y
      # We don't want enemies to be on top of each other
      if new_enemy.hit 'TheEnemy'
        new_enemy.destroy()
        @spawn_enemy()

    set_spawn_factor: (factor) ->
      console.log "Setting current spawn factor to #{factor}"
      @time_for_next_spawn = Conf.start_spawn_rate_in_ms * (1 / factor)


  Crafty.c 'MyText',
    init: ->
      @requires '2D, Canvas, Text'
      @textColor '#FDF6E3', 1
      @text 'Unset'
      @z = 1


  Crafty.c 'TitleText',
    init: ->
      @requires 'MyText'
      @textFont size: '40px', weight: 'bold'

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


  Crafty.c 'Screen',
    init: ->
      @requires '2D, Canvas, Color'
      @attr x: 0, y: 0, w: Conf.width, h: Conf.height
      @color 'rgb(0, 43, 54)'


  Crafty.c 'VictoryScreen',
    init: ->
      @requires 'Screen'
      Crafty.e('TitleText').titleText 'You won the game!'


  Crafty.c 'NewLevelScreen',
    init: ->
      @requires 'Screen'
      Crafty.e('TitleText').titleText 'Level'
      @timeout (-> Crafty.scene 'Game'), Conf.new_level_screen_timeout

    newLevelScreen: (level) ->
      Crafty.e('SubTitleText').subTitleText "#{level}"


  Crafty.c 'DefeatScreen',
    init: ->
      @requires 'Screen'
      Crafty.e('TitleText').titleText 'You lost the game!'

      retry_button = Crafty.e 'RetryButton'
      retry_button.attr Util.pos_to_center_entity retry_button
      retry_button.y += 50


  Crafty.c 'TextButton',
    init: ->
      @requires 'MyText, Mouse'
      @textFont size: '20px'

    textButton: (text, onClick) ->
      @text text
      @bind 'Click', onClick


  Crafty.c 'RetryButton',
    init: ->
      @requires 'TextButton'
      @textButton 'Retry', -> Crafty.scene 'NewLevel'


  # Exports
  {}
