admin =
  init: ->
    @editBook()
    @summernoteInit()
    @selectChapter()
    @saveChapter()
    @saveAndGenerateNewChapter()
    @destroyChapter()
    @resetPassword()
    @updateUserPlan()

  updateUserPlan: ->
    $(document).on 'click', 'button.update-user', (e) ->
      e.preventDefault()
      $('html, body').css("cursor", "wait");
      user_id = $(this).data('id')
      form = $('#form-primary-edit-' + user_id)
      data = { tariff_type: form.find('.user-tariff-type').chosen().val(), expire_date: form.find('.user-expire-date').val() }
      $.ajax
        type: 'POST'
        url: '/admin/users/update_tariff'
        data:
          id: user_id
          user: data
        dataType: "json"
        success: (data, textStatus, jqXHR) ->
          $('html, body').css("cursor", "auto")
          noty({text: 'Tariff for ' + data.user_email + ' was changed', type: 'success'})
          $('.md-modal.md-show .modal-header .md-close').click()
        error: (data, textStatus, jqXHR) ->
          noty({text: 'Server Error', type: 'error'});
          $('html, body').css("cursor", "auto");

  resetPassword: ->
    $(document).on 'click', '.reset-password', (e) ->
      e.preventDefault()
      user_id = $(this).data('id')
      form = $('#form-primary-reset-password-' + user_id)
      pass = form.find('.new-password').val()
      if pass is '' || pass.length < 6
        noty({text: "Password can't be empty or less then 6 symbols", type: 'error'});
        false
      else
        data = { email: form.find('.user-email').val(), password: pass, password: pass }
        $('html, body').css("cursor", "wait");
        $.ajax
          type: 'POST'
          url: '/admin/users/reset_password'
          data:
            id: user_id
            user: data
          dataType: "json"
          success: (data, textStatus, jqXHR) ->
            $('html, body').css("cursor", "auto")
            noty({text: 'Password for ' + data.user_email + ' was changed', type: 'success'})
            form.find('.new-password').val('')
            $('.md-modal.md-show .modal-header .md-close').click()
          error: (data, textStatus, jqXHR) ->
            noty({text: 'Server Error', type: 'error'});
            $('html, body').css("cursor", "auto");

  editBook: ->
    $(document).on 'click', '.books-list .edit-book', (e) ->
      e.preventDefault()
      window.document.location = $(this).data("href")

  summernoteInit: ->
    $('textarea.ckeditor').ckeditor()
    CKEDITOR.disableAutoInline = true
    $('.inline-editable').each ->
      CKEDITOR.inline $(this)[0]
    $('#some-textarea').wysihtml5()

    $('[data-provider="summernote"]').each ->
      $(this).summernote()

    $('#summernote3').summernote()
    current_chapter_id = $('#book-content .chapters-list li.active a.chapter').data("id")
    if current_chapter_id
      admin.getChapter(current_chapter_id)

  getChapter: (chapter_id) ->
    $('#summernote3').code('')
    $('.chapter-content .chapter-title').val('')
    $('html, body').css("cursor", "wait");
    $.ajax
      type: 'POST'
      url: '/admin/chapters/get_chapter'
      data:
        id: chapter_id
      dataType: "json"
      success: (data, textStatus, jqXHR) ->
        $('html, body').css("cursor", "auto");
        $('#summernote3').code(data.content)
        $('.chapter-content .chapter-title').val(data.title)
        $('.chapter-content .chapter-id').val(chapter_id)
        chap = $('#book-content .chapters-list li a.chapter[data-id="' + chapter_id + '"]')
        unless chap.parent().hasClass('active')
          chap.parent().addClass('active')

      error: (data, textStatus, jqXHR) ->
        $('html, body').css("cursor", "auto");

  selectChapter: ->
    $(document).on 'click', '#book-content .chapters-list li a.chapter', (e) ->
      e.preventDefault()
      $('#book-content .chapters-list li').removeClass('active')
      $(this).parent().addClass('active')
      admin.getChapter($(this).data("id"))

  collectDataForChapter: ->
    {
      title: $('.chapter-content .chapter-title').val(),
      content: $('#summernote3').code(),
      book_id: $('.chapter-content .book-id').val(),
      id: $('.chapter-content .chapter-id').val(),
    }

  updateChapterTemplate:  (data) ->
    noty({text: 'The chapter ' + data.title + ' was updated success', type: 'success'});
    $('html, body').css("cursor", "auto");
    $('#summernote3').code(data.content)
    $('.chapter-content .chapter-title').val(data.title)
    $('#book-content .chapters-list li.active a.chapter').text(data.title)

  destroyChapter: ->
    $("#chapters-form").on "click", "a.delete-chapter", (e) ->
      e.preventDefault()
      isGood = confirm('Are you sure?')
      if isGood
        chapter = $('#book-content .chapters-list li.active a.chapter')
        $('html, body').css("cursor", "wait");
        $.ajax
          type: 'POST'
          url: '/admin/chapters/destroy_chapter'
          data:
            chapter:
              id: chapter.data("id")
          dataType: "json"
          success: (data, textStatus, jqXHR) ->
            $('html, body').css("cursor", "auto")
            noty({text: 'The chapter ' + data.chapter_title + ' removed success', type: 'success'})

            if data.last_chapter_id?
              admin.getChapter(data.last_chapter_id)
            else
              $('.chapter-content').hide()

            chapter.parent().remove()
          error: (data, textStatus, jqXHR) ->
            noty({text: 'The chapter ' + data.chapter_title + ' not removed success', type: 'error'})
            $('html, body').css("cursor", "auto")

  saveAndGenerateNewChapter: ->
    $("#chapters-form").on "click", "a.update-and-create", (e) ->
      e.preventDefault()
      data_for_current = admin.collectDataForChapter()
      $('html, body').css("cursor", "wait");
      $.ajax
        type: 'POST'
        url: '/admin/chapters/save_chapter'
        data:
          chapter: data_for_current
        dataType: "json"
        success: (data, textStatus, jqXHR) ->
          admin.updateChapterTemplate(data)
          setTimeout (->
            $('.add-empty-chapter').click()
          ), 500
        error: (data, textStatus, jqXHR) ->
          noty({text: 'The chapter ' + data.title + ' not updated success', type: 'error'});
          $('html, body').css("cursor", "auto");

  saveChapter: ->
    $("#chapters-form").on "click", "input[type=\"submit\"]", (e) ->
      e.preventDefault()
      data = admin.collectDataForChapter()
      $('html, body').css("cursor", "wait");
      $.ajax
        type: 'POST'
        url: '/admin/chapters/save_chapter'
        data:
          chapter: data
        dataType: "json"
        success: (data, textStatus, jqXHR) ->
          admin.updateChapterTemplate(data)
        error: (data, textStatus, jqXHR) ->
          noty({text: 'The chapter ' + data.title + ' not updated success', type: 'error'});
          $('html, body').css("cursor", "auto");


$ ->
  admin.init()