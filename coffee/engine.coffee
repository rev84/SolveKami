$ ->
  for i in [1..20]
    $('#turn').append(
      $('<option>').attr('value', i).html(i)
    )
  for i in [1..20]
    $('#tate, #yoko').append(
      $('<option>').attr('value', i).html(i)
    )
  $('#tate, #yoko').on 'change', boardRedraw

  $('#tate').val(5)
  $('#yoko').val(5)
  boardRedraw()

  $('body').on 'mousemove', (e)->
    window.isMouseDown = e.buttons is 1
    e.preventDefault()

  $('#calc').on 'click', ->
    window.count = 0
    $('#board td').html('')

    b = getBoard()
    turn = Number $('#turn').val()

    res = Kami.solve b, turn
    # 解答が不正
    if res is false
      $('#message').html('NO ANSWER')
      return
    else
      $('#message').html('')
      for index in [0...res.length]
        [color, path] = res[index]
        [x, y] = path
        td = $('#board tr').eq(x).children('td').eq(y)
        $(td).html($(td).html()+'<br>['+(index+1)+']'+color)

window.isMouseDown = false
window.count = 0

window.boardRedraw = ->
  $('#board').empty()
  tate = Number $('#tate').val()
  yoko = Number $('#yoko').val()
  for t in [0...tate]
    tr = $('<tr>')
    for y in [0...yoko]
      tr.append(
        $('<td>').addClass('colora cell center').attr('value', 'a')
      )
    $('#board').append tr
  $('#board td').on 'mouseover', (e)->
    return if not window.isMouseDown
    value = $("input[name='color']:checked").val()
    $(this).attr 'value', value
    $(this).removeClass 'colora colorb colorc colord colore colorf'
    $(this).addClass 'color'+value

window.getBoard = ->
  x = []
  trs = $('#board tr')
  for tr in trs
    y = []
    tds = $(tr).children('td')
    for td in tds
      y.push $(td).attr 'value'
    x.push y
  x
