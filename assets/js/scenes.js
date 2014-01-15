define(['crafty', 'map'], function(Crafty, Map) {
  var level;
  level = 0;
  Crafty.scene('Game', function() {
    var enemy_spawner;
    console.log('Change to Game scene');
    Map.init();
    enemy_spawner = Crafty.e('EnemySpawner');
    return enemy_spawner.set_spawn_factor((level - 1) * 0.3 + 1);
  }, function() {
    return Crafty('EnemySpawner').each(function() {
      return this.destroy();
    });
  });
  Crafty.scene('Victory', function() {
    console.log('Change to Victory scene');
    return Crafty.e('VictoryScreen');
  });
  Crafty.scene('Defeat', function() {
    console.log('Change to Defeat scene');
    Crafty.e('DefeatScreen');
    return level = 0;
  });
  Crafty.scene('NewLevel', function() {
    console.log('Change to New Level scene');
    level += 1;
    console.log("Current level " + level);
    return Crafty.e('NewLevelScreen').newLevelScreen(level);
  });
  return {};
});
