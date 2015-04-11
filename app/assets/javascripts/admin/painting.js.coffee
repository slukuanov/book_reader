paints =
  init: ->
    @old_image
    @clearTempAttribute()
    @fileUploads()
    @cropping()

  clearTempAttribute: ->
    if $('#book_temp_image').length > 0
      $('#book_temp_image').val('')

  fileUploads: ->
    $('#book_image').fileupload
      dataType: "script"
      add: (e, data) ->
        types = /(\.|\/)(gif|jpe?g|png)$/i
        file = data.files[0]
        if types.test(file.type) || types.test(file.name)
          data.context = $(tmpl("template-upload", file))
          $('html, body').css("cursor", "wait");
          jqXHR = data.submit()
          .complete(
              (result, textStatus, jqXHR) ->
                new_url = JSON.parse(result.responseText).url
                $(".thumb-view-b").find("#cropbox").remove();
                paints.old_image = $("#cont_preview").find("#preview").attr("src")
                $("#cont_preview").find("#preview").remove();
                #paints.stopJcrop();
                $('.thumb-view-b').append("<img id='cropbox' src='" + new_url + "'>");
                paints.initModal();
                setTimeout ( ->
                  paints.initJcrop '#cropbox'
                  $('.view-container').css('display','block');
#                  $('#venue_class_image').append(data.context)
                  if $('#book_temp_image').length > 0
                    $('#book_temp_image').val(new_url)
                  tip = $('.res_tip')
                  $('.ui-dialog-buttonpane').prepend(tip);
                  $(".tip_new").css({ top: $('.ui-dialog').css('top').split('px')[0] - 150 });
                  tip.show();

                  $('html, body').css("cursor", "auto");
                ), 1500
          )
        else
          alert("#{file.name} is not a gif, jpeg, or png image file")

  cropping: ->
    if $('#cropbox').length > 0
      if $('#book_temp_image').length > 0
        setTimeout ( ->
          paints.initJcrop('#cropbox', [$('#book_crop_x').val(), $('#book_crop_y').val(), $('#book_crop_w').val(), $('#book_crop_h').val()]);
        ), 1500

  initModal: ->
    b_save = "Save"
    b_cancel = "Cancel"
    if lang is "fr_FR"
      b_save = "Sauvegarder"
      b_cancel = "Annuler"

    $('.thumb-view-b').dialog(
      width: 470
      draggable: false
      dialogClass: "no-close"
      buttons: [
        {
          text: b_cancel
          click: ->
            $(this).dialog "close"
            paints.stopJcrop()
            paints.clearTempAttribute()
            img = $('#cont_preview').find('#preview')
            if paints.old_image isnt undefined
              img.attr('src', paints.old_image)
              img.attr('style', '')
              $('#cont_preview').show()
        },
        {
          text: b_save
          click: ->
            $(this).dialog "close";
            paints.stopJcrop();
            $('#cont_preview').show();
            $('#new_version_image').val(1);
        }
      ]
    );
    $(".ui-dialog-titlebar").hide();

  update: (coords) =>
    ratio1 = 1
    if $('#book_temp_image').length > 0
      $('#book_crop_x').val(Math.floor (coords.x * ratio1))
      $('#book_crop_y').val(Math.floor (coords.y * ratio1))
      $('#book_crop_w').val(Math.floor (coords.w * ratio1))
      $('#book_crop_h').val(Math.floor (coords.h * ratio1))
    paints.updatePreview(coords)

  updatePreview: (coords) =>
    $("#preview").css
      width: Math.round(220/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(220/coords.h * $('#cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(220/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(220/coords.h * coords.y) + 'px'

  initJcrop: (id, crds=[]) ->
    width = $(id).width() + 30;
    height = $(id).height() + 30;
    $('#cont_preview').css('display','none');
    $('#cont_preview').append("<img id='preview' src='" + $(id).attr('src') + "'>");
    if crds.length > 0
      c = crds
    else
      c = [
          (width / 2) - (width / 2)
          (height / 2) - (height / 2)
          (width / 2 - width / 2) + width
          (height / 2) - (height / 2) + height
      ]
    window.jcrop_api = $.Jcrop(id,
      onSelect: @update
      onChange: @update
      bgColor: "black"
      bgOpacity: .4
      boxWidth: width
      boxHeight: height
      setSelect: c
      keySupport: false
      aspectRatio: 1
      allowSelect: false

    )
    return

  stopJcrop: ->
    jcrop_api.destroy()
    false

$ ->
  paints.init()