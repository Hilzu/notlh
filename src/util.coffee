define ['conf'], (Conf) ->
  pos_to_center_entity: (entity) ->
    x: Math.floor Conf.width / 2 - entity._w/ 2
    y: Math.floor Conf.height / 2 - entity._h / 2
