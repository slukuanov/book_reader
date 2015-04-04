$ ->
  $(document).on 'submit', '#registration-via-email-modal form, #login-modal form', (e) ->
    console.log '333'
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