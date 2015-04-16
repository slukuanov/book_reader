// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require auth.js
//= require ./reader/popModal.min.js
//= require noty/jquery.noty
//= require noty/layouts/topCenter
//= require noty/themes/default

$.noty.defaults.timeout = 8000
$.noty.defaults.layout = 'topCenter'

$(document).on('click', '.paid-book', function(e) {
    e.preventDefault();
    noty({text: 'This is not free book. Please upgrade your plan.', type: 'error'})
});

$(document).on('click', '.add-comment', function(e) {
    var that;
    e.preventDefault();
    that = $(this);
    return that.popModal({
        html : $('#comment-form').html(),
        placement : 'bottomLeft',
        showCloseBut : true,
        onDocumentClickClose : true,
        onDocumentClickClosePrevent : '',
        overflowContent : true,
        inline : true,
        beforeLoadingContent : 'Please, wait...',
        onOkBut : function() {
            var comment, id;
            id = that.data('id');
            comment = $('.popModal_content .comment-area').val();
            if (comment != '') {
                $.ajax({
                    type: 'POST',
                    url: '/books/add_comment_to_highlighter',
                    data: {
                        id: id,
                        comment: {
                            comment: comment,
                            title: 'empty'
                        }
                    },
                    dataType: "json",
                    success: function (data, textStatus, jqXHR) {
                        $(that).parents('.hightlight').find('ul.comments').append('<li>' + comment + '</li>');
                    },
                    error: function (data, textStatus, jqXHR) {
                    }
                });
            }
        },
        onCancelBut : function() {},
        onLoad : function() {},
        onClose : function() {}
    });
});
