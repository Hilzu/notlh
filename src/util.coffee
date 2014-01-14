define ['conf'], (Conf) ->
  if typeof Math.sign isnt 'function'
    Math.sign = (num) ->
      num = parseFloat(num)
      if num is 0 then 0
      else if num >= 0 then 1
      else if num <= 0 then -1
      else NaN


  # Exports
  pos_to_center_entity: (entity) ->
    x: Math.floor(Conf.width / 2 - entity._w / 2)
    y: Math.floor(Conf.height / 2 - entity._h / 2)

  ms_per_frame: 1000 / Crafty.timer.FPS()
