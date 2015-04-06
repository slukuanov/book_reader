$ ->
  $(document).on 'click', 'a.popup', (e) ->
    e.preventDefault()
    that = $(this)

    href = that.attr 'href'
    width = that.data 'width'
    height = that.data 'height'

    left = (screen.width/2) - (width/2)
    top = (screen.height/2) - (height/2)

    window.open href, 'funnoby popup', "menubar=no,toolbar=no,status=no,width=#{width},height=#{height},toolbar=no,left=#{left},top=#{top}"

    false

  $(document).on 'submit', '#registration-via-email-modal form, #login-modal form', (e) ->
    e.preventDefault()
    $('html, body').css("cursor", "wait");
    that = $(this)
    that.find(".input").removeClass('error_valid')
    $.ajax
      type: 'POST'
      url: that.attr 'action'
      data: that.serialize()
      dataType: "json"
      success: (data, textStatus, jqXHR) ->
        $('html, body').css("cursor", "auto");
        window.location.reload();
      error: (data, textStatus, jqXHR) ->
        $('html, body').css("cursor", "auto");
        $.each JSON.parse(data.responseText), (value) ->
          that.find(".input.user_#{value}").addClass('error_valid')