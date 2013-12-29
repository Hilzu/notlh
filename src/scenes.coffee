define ['crafty', 'map'], (Crafty, Map) ->
  text_css = 'font-size': '24px', 'font-family': 'Arial', 'color': 'white',
  'text-align': 'center'

  show_victory = ->
    console.log 'Visited a village'
    Crafty.scene 'Victory' if Crafty('Village').length is 0

  restart_game = ->
    Crafty.scene 'Game'


  Crafty.scene 'Game', ->
    Map.init()
    Crafty.audio.play 'ring'

    @bind 'VillageVisited', show_victory
  , ->
    @unbind 'VillageVisited', show_victory


  Crafty.scene 'Victory', ->
    Crafty.e('2D, DOM, Text').attr(x: 0, y: 0).text('Victory!').css(text_css)
    Crafty.audio.play 'applause'

    @bind 'KeyDown', restart_game
  , ->
    @unbind 'KeyDown', restart_game


  Crafty.scene 'Loading', ->
    Crafty.e('2D, DOM, Text')
      .text('Loading...')
      .attr(x: 0, y: Map.height / 2 - 24, w: Map.width)
      .css(text_css)

    Crafty.load ['assets/16x16_forest_2.gif',
                 'assets/hunter.png',
                 'assets/door_knock_3x.mp3',
                 'assets/board_room_applause.mp3',
                 'assets/candy_dish_lid.mp3'], ->

      Crafty.sprite 16, 'assets/16x16_forest_2.gif',
        spr_tree: [0, 0]
        spr_bush: [1, 0]
        spr_village: [0, 1]
        spr_rock: [1, 1]

      Crafty.sprite 16, 'assets/hunter.png',
        spr_player: [0, 2]
      , 0, 2

      Crafty.audio.add
        knock: ['assets/door_knock_3x.mp3']
        applause: ['assets/board_room_applause.mp3']
        ring: ['assets/candy_dish_lid.mp3']

      Crafty.scene 'Game'


  null
