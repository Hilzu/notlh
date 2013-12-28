define ['crafty'], (Crafty) ->
  start: ->
    console.log 'Starting game...'
    Crafty.init 480, 320
    Crafty.background 'green'
