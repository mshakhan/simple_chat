function showMainArea() {
  $('#main_area').show('slow');
  $('#message').focus();
}

function initUI() {
  $.each([
    '#main_area',
    '#chat_controls',
    'h3',
    '.chat_data_element'    
  ], function(i, el) { $(el).corner(); });
}

function initChat() {  
  var uname = prompt('Eneter you nickname');
    
  if (uname) {
    username = uname;
    $('#chat_url').text(location.href);
    $('#chat_url').attr('href', location.href);
    $('#nickname').text(username);
    $('#send').click(sendMessage);
    $('#message').keypress(function(e) {
      if (13 == e.which) { sendMessage(); } 
    });    
    runUpdates();
    showMainArea();    
  } else {
    var back = location.href
    location.href = '/unauthorized?back=' + back
  }
}

function runUpdates() {
  $(window).everyTime(4000, function() {
    $.getJSON('/last', 
      { room_id: room_id, user: username, last_time: last_time },
      function(data) {
        if (!data.error) {
          last_time = data.time;
          $.each(data.messages, function(i, msg) {
            appendMessage(msg[0], msg[1], msg[2]);
          });          
        } else if ('no_such_room' == data.error) {
          alertAndRedirectToRoot();        
        }
      });
  });  
}

function sendMessage() {
  var message_input = $('#message');
  
  var msg = message_input.val();
  message_input.val('');
  
  $.post('/add', {
    room_id: room_id,
    user: username,
    message: msg
  }, function(data) {
    if ('no_such_room' == data.error) {
      alertAndRedirectToRoot();
    }
  });
}

function appendMessage(user, msg, time) {
  time = new Date(time * 1000);
  time = timeToString(time);
  var id = 'message_' + message_counter++;
  
  var reply = msg.match(/@(\w+)/);
  if (reply) { reply = ' in reply to <a href="#">' + reply[1] + '</a>'; } 
  else { reply = ''; }
  
  $('#chat_area').append(
    '<div class="message_box" id="'+ id +'">' +
      '<div class="message_author">' +
        '<a href="#">' + user + '</a>' +
        reply +
      '</div>' +
      '<div class="message_time">' + time + '</div>' +
      '<div class="clear"></div>' +
      '<div class="message">' + msg + '</div>' +
    '</div>');
  
  var msg_div = $('#' + id);
  msg_div.corner();
  msg_div.find('a').click(function() {
    var msg_input = $('#message');
    msg_input.val(msg_input.val() + '@' + $(this).text() + ' ');
    $('#message').focus();
  }); 
  
  $('#chat_area').scrollTo('110%', '0%');
}

function timeToString(date) {
  var month = date.getMonth() + 1;
  var day = date.getDate();
  var year = date.getFullYear();
  var hour = date.getHours();
  if (hour < 10) { hour = '0' + hour; };
  var minute = date.getMinutes();
  if (minute < 10) { minute = '0' + minute; };
  var second = date.getSeconds();
  if (second < 10) { second = '0' + second; };
  return month + '/' + day + '/' + year + ' ' + hour + ':' + minute + ':' + second;   
}

function alertAndRedirectToRoot() {
  alert('No such room');
  location.href = '/';  
}
