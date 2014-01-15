define(['crafty'], function(Crafty) {
  var grid, init, init_barriers, init_grid_loc, pos_to_tile_loc, tile_loc_to_pos;
  grid = {
    x: 0,
    y: 0,
    height: 21,
    width: 18,
    tile_size: 32
  };
  init = function() {
    var x, y, _i, _j, _ref, _ref1;
    init_barriers();
    for (x = _i = 0, _ref = grid.width; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
      for (y = _j = 0, _ref1 = grid.height; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
        init_grid_loc({
          x: x,
          y: y
        });
      }
    }
    Crafty.e('PlayerCharacter').at({
      x: 8,
      y: 20
    });
    return Crafty.e('GreatAncientOne').at({
      x: 8,
      y: 0
    });
  };
  init_barriers = function() {
    var bottom_barrier, left_barrier, right_barrier, top_barrier;
    left_barrier = Crafty.e('Barrier').attr({
      x: grid.x - 1,
      y: grid.y - 1
    });
    left_barrier.size({
      width: 1,
      height: grid.height * grid.tile_size + 2
    });
    top_barrier = Crafty.e('Barrier').attr({
      x: grid.x - 1,
      y: grid.y - 1
    });
    top_barrier.size({
      width: grid.width * grid.tile_size + 2,
      height: 1
    });
    right_barrier = Crafty.e('Barrier').attr({
      x: grid.tile_size * grid.width + grid.x,
      y: grid.y - 1
    });
    right_barrier.size({
      width: 1,
      height: grid.height * grid.tile_size + 2
    });
    bottom_barrier = Crafty.e('Barrier').attr({
      x: grid.x - 1,
      y: grid.height * grid.tile_size + grid.y
    });
    return bottom_barrier.size({
      width: grid.width * grid.tile_size + 2,
      height: 1
    });
  };
  init_grid_loc = function(loc) {
    return Crafty.e('Tile').at(loc);
  };
  tile_loc_to_pos = function(tile_loc) {
    return {
      x: tile_loc.x * grid.tile_size + grid.x,
      y: tile_loc.y * grid.tile_size + grid.y
    };
  };
  pos_to_tile_loc = function(pos) {
    return {
      x: (pos.x - grid.x) / grid.tile_size,
      y: (pos.y - grid.y) / grid.tile_size
    };
  };
  return {
    grid: grid,
    init: init,
    pos_to_tile_loc: pos_to_tile_loc,
    tile_loc_to_pos: tile_loc_to_pos,
    tile_position: tile_loc_to_pos
  };
});
