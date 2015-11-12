# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('[id*=color]').change ->
    switch $(this).val()
      when "blue"
        $('.player1').attr("class", "player1 panel panel-primary")
      when "red"
        $('.player1').attr("class", "player1 panel panel-danger")
      when "orange"
        $('.player2').attr("class", "player2 panel panel-warning")
      when "green"
        $('.player2').attr("class", "player2 panel panel-success")


  window.ready = (num)->
    if $('.player'+num+' input[type*=text]').val()    
      $('.player'+num+' input[type*=text]').attr('readonly', true)
      $('.player'+num+' select').attr('disabled', true)
      $('.player'+num+' .ready_link').addClass 'hidden'
      log_message($('.player'+num+' input[type*=text]').val()+" is ready")
    else
      log_message("Player" +num+" name can't be blank")
    if $('.ready_link.hidden').length == 2
      log_message('Waiting for dice roll. Highest roll goes first')
      $('.roll_link').removeClass 'hidden'

  window.roll = (num) ->
    value = Math.floor((Math.random() * 6) + 1)
    while value == $('.player1 .roll_link.hidden').data('roll') || value == $('.player2 .roll_link.hidden').data('roll')
      value = Math.floor((Math.random() * 6) + 1)
    $('.player'+num+' .roll_link').addClass 'hidden'
    $('.player'+num+' .roll_link').attr('data-roll', value)
    log_message($('.player'+num+' input[type*=text]').val()+" has rolled "+value)
    if $('.roll_link.hidden').length == 2
      p1_roll = parseInt($('.player1 .roll_link.hidden').data('roll'))
      p2_roll = parseInt($('.player2 .roll_link.hidden').data('roll'))
      if p1_roll > p2_roll
        log_message $('.player1 input[type*=text]').val()+"'s turn"
        $('.player1').addClass 'active'
      else
        log_message $('.player2 input[type*=text]').val()+"'s turn"
        $('.player2').addClass 'active'
      log_message("Game Start")
      $('.arrows').removeClass 'hidden'
      get_active_turn ->
  
  get_active_turn = ->
    $('th').attr('class', 'text-center')
    if $('.player1').hasClass('active')
      $('th').addClass $('.player1 select').val()
      $('th').attr('data-color', $('.player1 select').val())
      window.active_color = $('.player1 select').val()
    else
      $('th').addClass $('.player2 select').val()
      $('th').attr('data-color', $('.player2 select').val())
      window.active_color = $('.player2 select').val()

  $('th').click ->
    col_num = $(this).data("col")
    active_color = window.active_color
    row = $('.table tr').find('td:nth-child('+col_num+')').not(".colored").last().parent('tr').data('row')
    #window.recent_x = col_num
    #window.recent_y = row
    $('.table tr').find('td:nth-child('+col_num+')').not(".colored").last().addClass("colored").find('.circle').addClass active_color
    if $('.table tr').find('td:nth-child('+col_num+')').not('.colored').length == 0
      $('th[data-col*='+col_num+']').unbind("click")
      log_message "Column full cant add more chip"  

    if active_color == $('.player1 select').val()
      if window.p1xy
        window.p1xy.push col_num+","+row
      else
        window.p1xy = [col_num+","+row]
    else
      if window.p2xy
        window.p2xy.push col_num+","+row
      else
        window.p2xy = [col_num+","+row]    
    end_turn ->
    switch_turn(active_color,col_num)

  switch_turn =(active_color,col_num) ->
    if $('.player1').hasClass('active')
      $('.player1').removeClass 'active'
      $('.player2').addClass 'active'
      log_message $('.player2 input[type*=text]').val()+"'s turn"
    else
      $('.player1').addClass 'active'
      $('.player2').removeClass 'active'
      log_message $('.player1 input[type*=text]').val()+"'s turn"
    get_active_turn ->

  end_turn = ->
    if $('.table td.colored').length > 6
      #checking for vertical    
      if window.p1xy.length >= 4 && window.active_color == $('.player1 select').val()
        coordinates = window.p1xy
      else
        coordinates = window.p2xy
      xy = coordinates[coordinates.length-1]
      x = xy.split(",")[0]
      y = xy.split(",")[1]
      vblock2 = x+","+(parseInt(y)+1).toString()
      vblock3 = x+","+(parseInt(y)+2).toString()
      vblock4 = x+","+(parseInt(y)+3).toString()
      
      #checking for horizontal
      if coordinates[0].split(',')[0] < 4
        hblock2 = (parseInt(x)-1).toString()+","+y
        hblock3 = (parseInt(x)-2).toString()+","+y
        hblock4 = (parseInt(x)-3).toString()+","+y
    
      else
        hblock2 = (parseInt(x)+1).toString()+","+y
        hblock3 = (parseInt(x)+2).toString()+","+y
        hblock4 = (parseInt(x)+3).toString()+","+y
        
      #checking for diagonal(left to right) \
      dl_rblock2 = (parseInt(x)+1).toString()+","+(parseInt(y)+1).toString()
      dl_rblock3 = (parseInt(x)+2).toString()+","+(parseInt(y)+2).toString()
      dl_rblock4 = (parseInt(x)+3).toString()+","+(parseInt(y)+3).toString()

      #checking for diagonal(right to left) /
      if coordinates[0].split(',')[0] > 4
        dr_lblock2 = (parseInt(x)+1).toString()+","+(parseInt(y)-1).toString()
        dr_lblock3 = (parseInt(x)+2).toString()+","+(parseInt(y)-2).toString()
        dr_lblock4 = (parseInt(x)+3).toString()+","+(parseInt(y)-3).toString()
      else
        dr_lblock2 = (parseInt(x)-1).toString()+","+(parseInt(y)+1).toString()
        dr_lblock3 = (parseInt(x)-2).toString()+","+(parseInt(y)+2).toString()
        dr_lblock4 = (parseInt(x)-3).toString()+","+(parseInt(y)+3).toString()
            
      if coordinates.indexOf(vblock2) != -1 && coordinates.indexOf(vblock3) != -1 && coordinates.indexOf(vblock4) != -1 
        if window.active_color == $('.player1 select').val()
          alert $('.player1 input[type*=text]').val()+ " wins!"
         else
          alert $('.player2 input[type*=text]').val()+ " wins!"        
        console.log "vertical"
        window.location.reload()
        
      if coordinates.indexOf(hblock2) != -1 && coordinates.indexOf(hblock3) != -1 && coordinates.indexOf(hblock4) != -1
        if window.active_color == $('.player1 select').val()
          alert $('.player1 input[type*=text]').val()+ " wins!"
         else
          alert $('.player2 input[type*=text]').val()+ " wins!"
        console.log "horizontal"
        window.location.reload()
      
      if coordinates.indexOf(dl_rblock2) != -1 && coordinates.indexOf(dl_rblock3) != -1 && coordinates.indexOf(dl_rblock4) != -1
        if window.active_color == $('.player1 select').val()
          alert $('.player1 input[type*=text]').val()+ " wins!"
        else
          alert $('.player2 input[type*=text]').val()+ " wins!"
        console.log "left to right"
        window.location.reload()
      
      if coordinates.indexOf(dr_lblock2) != -1 && coordinates.indexOf(dr_lblock3) != -1 && coordinates.indexOf(dr_lblock4) != -1
        if window.active_color == $('.player1 select').val()
          alert $('.player1 input[type*=text]').val()+ " wins!"
        else
          alert $('.player2 input[type*=text]').val()+ " wins!"
        console.log "right to left"
        window.location.reload()
      
 
  log_message = (msg)->
    $('.log').append('<p class=text-muted>'+msg+'</p>').scrollTop($('.log').prop('scrollHeight'))

