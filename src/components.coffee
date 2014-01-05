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


  Crafty.c 'GreatAncientOne',
    init: ->
      @requires 'Tile'
      @color 'rgb(211, 54, 130)'


  Crafty.c 'VictoryScreen',
    init: ->
      @requires '2D, Canvas, Color'
      @attr x: 0, y: 0, w: Conf.width, h: Conf.height
      @color 'rgb(0, 43, 54)'
      victory_text = Crafty.e('2D, Canvas, Text').text('You won the game!')
      victory_text.textColor('#FDF6E3', 1)
      victory_text.textFont(size: '40px', weight: 'bold')
      victory_text.attr Util.pos_to_center_entity(victory_text)
