let buttons = [],
  submenus = [],
  normalButtons = 0
$(document).ready(function () {
  function _0x4f3204() {
    $('.container li').each(function (_0x19633b) {
      let _0x1af345 = _0x19633b * (360 / $('.container li').length),
        _0x864e2d = 130 * Math.cos(_0x1af345 * (Math.PI / 180)),
        _0x5dda7a = 130 * Math.sin(_0x1af345 * (Math.PI / 180))
      setTimeout(() => {
        $(this).css({
          transform: 'translate(-50%, -50%) translate(' + _0x864e2d + 'px, ' + _0x5dda7a + 'px)',
          opacity: 1,
        })
      }, _0x19633b * 50)
    })
  }
  function _0x2a45c1() {
    $('.container li').css({
      transform: 'translate(-50%, -50%) translate(0, 0)',
      opacity: 0,
    })
  }
  function _0x35affe() {
    buttons.length = 0
    submenus.length = 0
    normalButtons = 0
    $.post('http://dynamic/close')
    $('.container').removeClass('active')
    $('#body').fadeOut(250)
    _0x2a45c1()
    normalButtons = 0
    buttons.length = 0
    submenus.length = 0
    $('.container').html(
      '\n        <div class="background"></div>\n        <div class="goback first">Sair</div>'
    )
  }
  document.onkeyup = function (_0x15571d) {
    if (_0x15571d.which == 27) {
      _0x35affe()
    } else {
      if (_0x15571d.which == 8) {
        $('li').remove()
        for (i = 0; i < buttons.length; ++i) {
          let _0x4d60e8 = buttons[i],
            _0x476604 = _0x4d60e8.match('normalbutton')
          _0x476604 && $('.container').prepend(_0x4d60e8)
        }
        $('.container').append(submenus).show()
      }
    }
  }
  window.addEventListener('message', function (_0x2ed693) {
    let _0x359d5d = _0x2ed693.data
    if (_0x359d5d.addbutton == true) {
      if (_0x359d5d.id == false || null) {
        normalButtons = normalButtons + 1
        let _0x4c6b33 =
          '<li id="normalbutton-' +
          normalButtons +
          '" data-trigger="' +
          _0x359d5d.trigger +
          '" data-parm="' +
          _0x359d5d.par +
          '" data-server="' +
          _0x359d5d.server +
          '" data-cooldown="' +
          _0x359d5d.validCooldown +
          '" class="btn normalbutton"><a>' +
          _0x359d5d.title +
          '</a></li>'
        $('.container').append(_0x4c6b33)
        buttons.push(_0x4c6b33)
      } else {
        let _0xf8255f =
          '<li id="' +
          _0x359d5d.id +
          '"data-trigger="' +
          _0x359d5d.trigger +
          '" data-parm="' +
          _0x359d5d.par +
          '" data-server="' +
          _0x359d5d.server +
          '" data-cooldown="' +
          _0x359d5d.validCooldown +
          '" class="a btn"><a>' +
          _0x359d5d.title +
          '</a></li>'
        buttons.push(_0xf8255f)
      }
    } else {
      if (_0x359d5d.addmenu == true) {
        let _0x21dd18 =
          '<li data-menu="' +
          _0x359d5d.menuid +
          '"class="b btn"><a>' +
          _0x359d5d.title +
          '</a></li>'
        $('.container').append(_0x21dd18)
        submenus.push(_0x21dd18)
      }
    }
    _0x359d5d.close == true && _0x35affe()
    if (_0x359d5d.show == true) {
      $('#body').css('display', 'flex').hide().fadeIn(250)
      $('.container').show()
      $('.container').addClass('active')
      setTimeout(() => {
        _0x4f3204()
      }, 300)
    }
  })
  $('body').on('click', '.normalbutton', function () {
    $.post(
      'http://dynamic/clicked',
      JSON.stringify({
        trigger: $(this).attr('data-trigger'),
        param: $(this).attr('data-parm'),
        server: $(this).attr('data-server'),
        validCooldown: $(this).attr('data-cooldown'),
      })
    )
  })
  $('body').on('click', '.a', function () {
    $.post(
      'http://dynamic/clicked',
      JSON.stringify({
        trigger: $(this).attr('data-trigger'),
        param: $(this).attr('data-parm'),
        server: $(this).attr('data-server'),
        validCooldown: $(this).attr('data-cooldown'),
      })
    )
  })
  $('body').on('click', '.b', function () {
    $('.goback').removeClass('first')
    $('.goback').html('Voltar')
    $('.b').remove()
    $('.a').remove()
    for (i = 0; i <= normalButtons; ++i) {
      $('#normalbutton-' + i).remove()
    }
    let _0x19ee64 = $(this).attr('data-menu')
    for (i = 0; i < buttons.length; ++i) {
      let _0x53d221 = buttons[i],
        _0x455dbf = _0x53d221.match('id="' + _0x19ee64 + '"')
      _0x455dbf && $('.container').append(_0x53d221)
    }
    _0x4f3204()
  })
  $('body').on('click', '.goback', function () {
    if ($(this).hasClass('first')) {
      _0x35affe()
      return
    }
    $('.b').remove()
    $('.a').remove()
    $('li').remove()
    $('.goback').addClass('first')
    $('.goback').html('Sair')
    $('.container').append(submenus).show()
    for (i = 0; i < buttons.length; ++i) {
      let _0x1eb97b = buttons[i],
        _0x41df38 = _0x1eb97b.match('normalbutton')
      _0x41df38 && $('.container').append(_0x1eb97b)
    }
    _0x4f3204()
  })
})
