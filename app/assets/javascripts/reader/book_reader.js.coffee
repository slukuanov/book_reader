$ ->
  window.setCurrentChapter = (user_book_id, chapter_id) ->
    $.ajax
      type: 'POST'
      url: '/book_readers/update_current_chapter'
      data:
        books_user:
          id: user_book_id
          current_chapter_id: chapter_id
      dataType: "json"
      success: (data, textStatus, jqXHR) ->
      error: (data, textStatus, jqXHR) ->