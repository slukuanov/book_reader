highlight =
  init: ->
    @initTextHighlighter()
    @highlighterManage()

  highlighterModal: (highligh, range) ->
    that = $(highligh)
    that.popModal
      html: '<a href="#" data-popmodal-but="ok"><i class="fa fa-pencil"></i></a>'
      placement: 'rightCenter'
      showCloseBut: true
      onDocumentClickClose: true
      onDocumentClickClosePrevent: ''
      overflowContent: false
      inline: true
      beforeLoadingContent: 'Please, wait...'
      onOkBut: ->
        that.removeClass('pre-highlight')
        window.saveHighlighter(that.html())
      onCancelBut: ->
      onLoad: ->
        that.addClass('pre-highlight')
      onClose: ->
        if that.hasClass('pre-highlight')
          html = that.html()
          that.after(html)
          that.remove()

  highlighterManage: ->
    $(document).on 'click', 'span.highlighted, span.highlight', (e) ->
      e.preventDefault()
      that = $(this)
      that.popModal
        html: '<a href="#" data-popmodal-but="ok"><i class="fa fa-pencil-square"></i></a>'
        placement: 'rightCenter'
        showCloseBut: true
        onDocumentClickClose: true
        onDocumentClickClosePrevent: ''
        overflowContent: false
        inline: true
        beforeLoadingContent: 'Please, wait...'
        onOkBut: ->
          html = that.html()
          that.after(html)
          that.remove()
          window.removeHighlighter(that.html())
        onCancelBut: ->
        onLoad: ->
        onClose: ->

  initTextHighlighter: ->
    sandbox = document.getElementById('bb-bookblock')
    window.hltr = new TextHighlighter(sandbox,
      onBeforeHighlight: (range) ->
        return true
      onAfterHighlight: (range, highlights) ->
        setTimeout (->
          highlight.highlighterModal(highlights[0], range)
          highlights.shift()
          highlights.map((h) ->
            that = $(h)
            html = that.html()
            that.after(html)
            that.remove()
          ).join(', ')
        ), 200
        return
    )
reader =
  init: ->
    @manageFavorite()

  changeFavButton: (that, is_fav) ->
    if is_fav
      that.removeClass('add-to-favorite')
      that.addClass('remove-from-favorite')
      that.find('i').removeClass('fa-star')
      that.find('i').addClass('fa-star-o')
      that.find('span').text('DEL FROM FAVORITE')
    else
      that.addClass('add-to-favorite')
      that.removeClass('remove-from-favorite')
      that.find('i').addClass('fa-star')
      that.find('i').removeClass('fa-star-o')
      that.find('span').text('ADD TO FAVORITE')

  manageFavorite: ->
    $(document).on 'click', '.favorite-manage', (e) ->
      e.preventDefault()
      $('html, body').css("cursor", "wait")
      that = $(this)
      user_book_id = that.data('user-book-id')
      is_fav = that.hasClass('add-to-favorite')
      mess = if is_fav then 'added to' else 'removed from'
      $.ajax
        type: 'POST'
        url: '/book_readers/update_book'
        data:
          books_user:
            id: user_book_id
            favorite: if is_fav then 1 else 0
        dataType: "json"
        success: (data, textStatus, jqXHR) ->
          $('html, body').css("cursor", "auto")
          reader.changeFavButton(that, is_fav)
          noty({text: 'Book ' + mess + ' your favorite list', type: 'success'})
        error: (data, textStatus, jqXHR) ->
          noty({text: 'Server Error', type: 'error'});
          $('html, body').css("cursor", "auto");

$ ->
  reader.init()
  highlight.init()
  window.setCurrentChapter = (user_book_id, chapter_id) ->
    $.ajax
      type: 'POST'
      url: '/book_readers/update_book'
      data:
        books_user:
          id: user_book_id
          current_chapter_id: chapter_id
      dataType: "json"
      success: (data, textStatus, jqXHR) ->
      error: (data, textStatus, jqXHR) ->

  window.saveHighlighter = (text) ->
    user_book_id = $('#menu-toc li.menu-toc-current').data('user-book-id')
    chapter_id = $('#menu-toc li.menu-toc-current').data('chapter-id')
    $.ajax
      type: 'POST'
      url: '/book_readers/save_highlighter'
      data:
        highlight:
          books_user_id: user_book_id
          content: text
          chapter_id: chapter_id
      dataType: "json"
      success: (data, textStatus, jqXHR) ->
      error: (data, textStatus, jqXHR) ->
        noty({text: 'Server Error', type: 'error'});

  window.removeHighlighter = (text) ->
    user_book_id = $('#menu-toc li.menu-toc-current').data('user-book-id')
    chapter_id = $('#menu-toc li.menu-toc-current').data('chapter-id')
    $.ajax
      type: 'POST'
      url: '/book_readers/remove_highlighter'
      data:
        highlight:
          books_user_id: user_book_id
          content: text
          chapter_id: chapter_id
      dataType: "json"
      success: (data, textStatus, jqXHR) ->
      error: (data, textStatus, jqXHR) ->
        noty({text: 'Server Error', type: 'error'});
