define ['crafty', 'map'], (Crafty, Map) ->
  Crafty.c 'Grid',
    init: ->
      @attr w: Map.grid.tile.width, h: Map.grid.tile.height

    at: (x, y) ->
      if x? and y?
        @attr x: x * Map.grid.tile.width, y: y * Map.grid.tile.height
      else
        x: @x / Map.grid.tile.width, y: @y / Map.grid.tile.height


  Crafty.c 'Actor',
    init: ->
      @requires '2D, Canvas, Grid'


  Crafty.c 'Tree',
    init: ->
      @requires 'Actor, Solid, spr_tree'


  Crafty.c 'Bush',
    init: ->
      @requires 'Actor, Solid, spr_bush'


  Crafty.c 'Rock',
    init: ->
      @requires 'Actor, Solid, spr_rock'


  Crafty.c 'PlayerCharacter',
    init: ->
      @requires 'Actor, Fourway, Collision, spr_player, SpriteAnimation'
      @fourway 2
      @stopOnSolids()
      @onHit 'Village', @visitVillage
      @reel 'PlayerMovingUp', 500, 0, 0, 3
      @reel 'PlayerMovingRight', 500, 0, 1, 3
      @reel 'PlayerMovingDown', 500, 0, 2, 3
      @reel 'PlayerMovingLeft', 500, 0, 3, 3
      @bind 'NewDirection', @change_direction

    change_direction: (data) ->
      if data.x > 0
        @animate 'PlayerMovingRight', -1
      else if data.x < 0
        @animate 'PlayerMovingLeft', -1
      else if data.y > 0
        @animate 'PlayerMovingDown', -1
      else if data.y < 0
        @animate 'PlayerMovingUp', -1
      else
        @pauseAnimation()

    stopOnSolids: ->
      @onHit 'Solid', @stopMovement

    stopMovement: ->
      @_speed = 0
      if @_movement
        @x -= @_movement.x
        @y -= @_movement.y

    visitVillage: (data) ->
      village = data[0].obj
      village.visit()


  Crafty.c 'Village',
    init: ->
      @requires 'Actor, spr_village'

    visit: ->
      @destroy()
      Crafty.audio.play 'knock'
      Crafty.trigger 'VillageVisited', @


  null
