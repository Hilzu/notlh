define(['crafty', 'conf', 'map', 'util'], function(Crafty, Conf, Map, Util) {
  Crafty.c('Tile', {
    init: function() {
      this.requires('2D, Canvas, Color');
      this.attr({
        w: Map.grid.tile_size,
        h: Map.grid.tile_size
      });
      return this.color('rgb(7, 54, 66)');
    },
    at: function(loc) {
      var pos;
      if ((loc != null) && (loc.x != null) && (loc.y != null)) {
        pos = Map.tile_loc_to_pos(loc);
        return this.attr({
          x: pos.x,
          y: pos.y
        });
      } else {
        return Map.pos_to_tile_loc({
          x: this._x,
          y: this._y
        });
      }
    }
  });
  Crafty.c('Barrier', {
    init: function() {
      this.requires('2D, Canvas, Color, Solid');
      return this.color('rgb(220, 50, 47)');
    },
    size: function(size) {
      if ((size != null) && (size.width != null) && (size.height != null)) {
        return this.attr({
          w: size.width,
          h: size.height
        });
      } else {
        return {
          width: this._w,
          height: this._h
        };
      }
    }
  });
  Crafty.c('PlayerCharacter', {
    focused: false,
    init: function() {
      this.requires('Tile, Fourway, Collision, Keyboard');
      this.color('rgb(42, 161, 152)');
      this.fourway(Conf.player_speed);
      this.onHit('Solid', this.stop_movement);
      this.onHit('GreatAncientOne', this.meet_the_ancient);
      this.onHit('TheEnemy', this.die);
      this.bind('KeyDown', this.key_down);
      return this.bind('KeyUp', this.key_up);
    },
    stop_movement: function() {
      if (this._movement) {
        this.y -= this._movement.y;
        if (this.hit('Solid')) {
          this.x -= this._movement.x;
        }
        this.y += this._movement.y;
        if (this.hit('Solid')) {
          return this.y -= this._movement.y;
        }
      }
    },
    meet_the_ancient: function() {
      return Crafty.scene('NewLevel');
    },
    die: function() {
      Crafty.pause(true);
      Crafty.e('TitleText').titleText('Dead!');
      return this.timeout(function() {
        Crafty.pause(false);
        return Crafty.scene('Defeat');
      }, Conf.death_screen_timeout);
    },
    key_down: function() {
      if (this.isDown('SHIFT') && !this.focused) {
        this.focused = true;
        return this.change_speed(Conf.player_speed * Conf.player_focus_speed_factor);
      }
    },
    key_up: function() {
      if (!this.isDown('SHIFT') && this.focused) {
        this.focused = false;
        return this.change_speed(Conf.player_speed);
      }
    },
    change_speed: function(new_speed) {
      this.speed({
        x: new_speed,
        y: new_speed
      });
      this._movement.x = Math.sign(this._movement.x) * new_speed;
      return this._movement.y = Math.sign(this._movement.y) * new_speed;
    }
  });
  Crafty.c('GreatAncientOne', {
    init: function() {
      this.requires('Tile');
      return this.color('rgb(211, 54, 130)');
    }
  });
  (function() {
    var enemy_speed;
    enemy_speed = Conf.enemy_speed / Util.ms_per_frame;
    return Crafty.c('TheEnemy', {
      init: function() {
        this.requires('Tile, Enemy, Collision');
        this.color('rgb(108, 113, 196)');
        return this.bind('EnterFrame', this.move_);
      },
      move_: function(data) {
        this.y += enemy_speed * data.dt;
        if (this._y > Conf.height) {
          return this.destroy();
        }
      }
    });
  })();
  Crafty.c('EnemySpawner', {
    time_for_next_spawn: Conf.start_spawn_rate_in_ms,
    time_since_last_spawn: 0,
    init: function() {
      return this.bind('EnterFrame', this.spawn_enemy_if_time);
    },
    spawn_enemy_if_time: function(data) {
      this.time_since_last_spawn += data.dt;
      if (this.time_since_last_spawn >= this.time_for_next_spawn) {
        this.time_since_last_spawn = 0;
        return this.spawn_enemy();
      }
    },
    spawn_enemy: function() {
      var enemy_x, enemy_y, new_enemy;
      enemy_x = Math.floor(Math.random() * (Map.grid.width * Map.grid.tile_size - Map.grid.tile_size) + Map.grid.x);
      enemy_y = -40;
      new_enemy = Crafty.e('TheEnemy').attr({
        x: enemy_x,
        y: enemy_y
      });
      if (new_enemy.hit('TheEnemy')) {
        new_enemy.destroy();
        return this.spawn_enemy();
      }
    },
    set_spawn_factor: function(factor) {
      console.log("Setting current spawn factor to " + factor);
      return this.time_for_next_spawn = Conf.start_spawn_rate_in_ms * (1 / factor);
    }
  });
  Crafty.c('MyText', {
    init: function() {
      this.requires('2D, Canvas, Text');
      this.textColor('#FDF6E3', 1);
      this.text('Unset');
      return this.z = 1;
    }
  });
  Crafty.c('TitleText', {
    init: function() {
      this.requires('MyText');
      return this.textFont({
        size: '40px',
        weight: 'bold'
      });
    },
    titleText: function(text) {
      this.text(text);
      return this.attr(Util.pos_to_center_entity(this));
    }
  });
  Crafty.c('SubTitleText', {
    init: function() {
      this.requires('TitleText');
      return this.textFont({
        size: '20px'
      });
    },
    subTitleText: function(text) {
      this.text(text);
      this.attr(Util.pos_to_center_entity(this));
      return this.y += 50;
    }
  });
  Crafty.c('Screen', {
    init: function() {
      this.requires('2D, Canvas, Color');
      this.attr({
        x: 0,
        y: 0,
        w: Conf.width,
        h: Conf.height
      });
      return this.color('rgb(0, 43, 54)');
    }
  });
  Crafty.c('VictoryScreen', {
    init: function() {
      this.requires('Screen');
      return Crafty.e('TitleText').titleText('You won the game!');
    }
  });
  Crafty.c('NewLevelScreen', {
    init: function() {
      this.requires('Screen');
      Crafty.e('TitleText').titleText('Level');
      return this.timeout((function() {
        return Crafty.scene('Game');
      }), Conf.new_level_screen_timeout);
    },
    newLevelScreen: function(level) {
      return Crafty.e('SubTitleText').subTitleText("" + level);
    }
  });
  Crafty.c('DefeatScreen', {
    init: function() {
      var retry_button;
      this.requires('Screen');
      Crafty.e('TitleText').titleText('You lost the game!');
      retry_button = Crafty.e('RetryButton');
      retry_button.attr(Util.pos_to_center_entity(retry_button));
      return retry_button.y += 50;
    }
  });
  Crafty.c('TextButton', {
    init: function() {
      this.requires('MyText, Mouse');
      return this.textFont({
        size: '20px'
      });
    },
    textButton: function(text, onClick) {
      this.text(text);
      return this.bind('Click', onClick);
    }
  });
  Crafty.c('RetryButton', {
    init: function() {
      this.requires('TextButton');
      return this.textButton('Retry', function() {
        return Crafty.scene('NewLevel');
      });
    }
  });
  return {};
});
