define [], ->
  bush_chance = 0.06
  max_villages = 5
  rock_chance = 0.03
  village_chance = 0.02

  grid =
    width: 24
    height: 16
    tile:
      width: 16
      height: 16

  static_actors =
    '5,5': 'PlayerCharacter'

  get_static_actor = (x, y) -> static_actors["#{x},#{y}"]

  has_static_actor = (x, y) -> (get_static_actor x, y)?

  init = ->
    for x in [0...grid.width]
      for y in [0...grid.height]
        init_grid_location x, y

  init_grid_location = (x, y) ->
    if has_static_actor x, y
      place_actor_at (get_static_actor x, y), x, y
    else if at_edge x, y
      place_actor_at 'Tree', x, y
    else if Math.random() < bush_chance
      place_actor_at 'Bush', x, y
    else if Math.random() < rock_chance
      place_actor_at 'Rock', x, y
    else if Math.random() < village_chance and
    Crafty('Village').length < max_villages
      place_actor_at 'Village', x, y

  place_actor_at = (actor, x, y) ->
    Crafty.e(actor).at x, y

  at_edge = (x, y) ->
    x is 0 or x is grid.width - 1 or y is 0 or y is grid.height - 1

  height = ->
    grid.height * grid.tile.height

  width = ->
    grid.width * grid.tile.width

  # Exported object
  at_edge: at_edge
  height: height()
  init: init
  grid: grid
  width: width()
