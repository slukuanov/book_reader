//= require jquery_ujs
//= require chosen.jquery
//= require summernote
//= require_tree ./admin
//= require noty/jquery.noty
//= require noty/layouts/topCenter
//= require noty/themes/default

$.noty.defaults.timeout = 8000
$.noty.defaults.layout = 'topCenter'

$(function() {
    $(".chzn-select").chosen();
});