define(['conf'], function(Conf) {
  if (typeof Math.sign !== 'function') {
    Math.sign = function(num) {
      num = parseFloat(num);
      if (num === 0) {
        return 0;
      } else if (num > 0) {
        return 1;
      } else if (num < 0) {
        return -1;
      } else {
        return NaN;
      }
    };
  }
  return {
    pos_to_center_entity: function(entity) {
      return {
        x: Math.floor(Conf.width / 2 - entity._w / 2),
        y: Math.floor(Conf.height / 2 - entity._h / 2)
      };
    },
    ms_per_frame: 1000 / Crafty.timer.FPS()
  };
});
