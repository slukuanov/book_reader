admin =
  init: ->
    @editBook()
    @summernoteInit()
    @selectChapter()
    @saveChapter()

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
    admin.getChapter($('#book-content .chapters-list li.active a.chapter').data("id"))

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
      error: (data, textStatus, jqXHR) ->
        $('html, body').css("cursor", "auto");

  selectChapter: ->
    $(document).on 'click', '#book-content .chapters-list li a.chapter', (e) ->
      e.preventDefault()
      $('#book-content .chapters-list li').removeClass('active')
      $(this).parent().addClass('active')
      admin.getChapter($(this).data("id"))

  saveChapter: ->
    $("#chapters-form").on "click", "input[type=\"submit\"]", (e) ->
      e.preventDefault()
      data = {
        title: $('.chapter-content .chapter-title').val(),
        content: $('#summernote3').code(),
        book_id: $('.chapter-content .book-id').val(),
        id: $('.chapter-content .chapter-id').val(),
      }

      $('html, body').css("cursor", "wait");
      $.ajax
        type: 'POST'
        url: '/admin/chapters/save_chapter'
        data:
          chapter: data
        dataType: "json"
        success: (data, textStatus, jqXHR) ->
          noty({text: 'The chapter ' + data.title + ' was updated success', type: 'success'});
          $('html, body').css("cursor", "auto");
          $('#summernote3').code(data.content)
          $('.chapter-content .chapter-title').val(data.title)
          $('#book-content .chapters-list li.active a.chapter').text(data.title)
        error: (data, textStatus, jqXHR) ->
          noty({text: 'The chapter ' + data.title + ' not updated success', type: 'error'});
          $('html, body').css("cursor", "auto");


$ ->
  admin.init()