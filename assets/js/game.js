define(['crafty', 'conf', 'components', 'map', 'scenes'], function(Crafty, Conf, Comp, Map, Scenes) {
  var start;
  start = function() {
    console.log('Starting game...');
    Crafty.init(Conf.width, Conf.height);
    Crafty.background('rgb(0, 43, 54)');
    Map.grid.x = 12;
    Map.grid.y = 28;
    return Crafty.scene('NewLevel');
  };
  return {
    start: start
  };
});
