window.resize = ->
  window.columnWidth = $(window).width() / 3
  window.boardWidth = $(window).width() * (0.34 * $('.column').length)
  window.columnHeight = $(window).height() - $('nav').height() - $('#columns header').height()
  $('#columns .board .column').width window.columnWidth
  $('#columns .board-inner').width window.boardWidth
  $('#columns .board .column').height window.columnHeight + $('nav aside').height()

window.preventClick = false

window.correspondiente = ->
  if navigator.userAgent.match /iPad|Chrome/
    return $('body')
  else
    return $('html')

$ ->
  window.resize()
  $(window).resize window.resize

  correspondiente().scrollTop $('nav aside').height()

  $('*').bind 'touchend', ->
    $(this).click()
    if window.preventClick
      if correspondiente().scrollTop() > 50
        correspondiente().animate { scrollTop: 150 }, 150, 'easeOutQuad'
      else
        correspondiente().animate { scrollTop: 0 }, 150, 'easeOutQuad'
    return false

  $('nav > section a').click ->
    unless window.preventClick
      if not $('nav aside section').hasClass 'hide'
        alert("asdf")
      $('nav aside section').addClass 'hide'
      $("nav aside section." + $(this).attr('rel')).removeClass 'hide'
      if correspondiente().scrollTop() == 150
        correspondiente().animate { scrollTop: 0 }, 150, 'easeOutQuad' 
    else
      preventClick.window = false

  $(window).click (e) ->
    if $('nav').find($(e.target)).length == 0
      unless window.preventClick
        unless correspondiente().scrollTop() == 150
          correspondiente().animate { scrollTop: $('nav aside').height() }, 150, 'easeOutQuad'
      else
        window.preventClick = false
      #$('nav aside').addClass 'no-height'

  $(window).bind 'touchmove', ->
    window.preventClick = true
    return false