define ['crafty', 'map'], (Crafty, Map) ->
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

    stop_movement: ->
      if @_movement
        @x -= @_movement.x
        @y -= @_movement.y

        @x += @_movement.x
        @x -= @_movement.x if @hit('Solid')

        @y += @_movement.y
        @y -= @_movement.y if @hit('Solid')
