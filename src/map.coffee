define ['crafty'], (Crafty) ->
  grid =
    x: 0
    y: 0
    height: 21
    width: 18
    tile_size: 32

  init = ->
    init_barriers()

    for x in [0...grid.width]
      for y in [0...grid.height]
        init_grid_loc x: x, y: y
    Crafty.e('PlayerCharacter').at x: 8, y: 20

  init_barriers = ->
    left_barrier = Crafty.e('Barrier').attr x: grid.x - 1, y: grid.y - 1
    left_barrier.size width: 1, height: grid.height * grid.tile_size + 2
    top_barrier = Crafty.e('Barrier').attr x: grid.x - 1, y: grid.y - 1
    top_barrier.size width: grid.width * grid.tile_size + 2, height: 1
    right_barrier = Crafty.e('Barrier').attr
      x: grid.tile_size * grid.width + grid.x, y: grid.y - 1
    right_barrier.size width: 1, height: grid.height * grid.tile_size + 2
    bottom_barrier = Crafty.e('Barrier').attr
      x: grid.x - 1, y: grid.height * grid.tile_size + grid.y
    bottom_barrier.size width: grid.width * grid.tile_size + 2, height: 1

  init_grid_loc = (loc) ->
    Crafty.e('Tile').at loc

  tile_loc_to_pos = (tile_loc) ->
    x: tile_loc.x * grid.tile_size + grid.x
    y: tile_loc.y * grid.tile_size + grid.y

  pos_to_tile_loc = (pos) ->
    x: (pos.x - grid.x) / grid.tile_size
    y: (pos.y - grid.y) / grid.tile_size


  # Exports
  grid: grid
  init: init
  pos_to_tile_loc: pos_to_tile_loc
  tile_loc_to_pos: tile_loc_to_pos
  tile_position: tile_loc_to_pos
