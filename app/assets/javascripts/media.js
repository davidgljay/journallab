// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('click', '.popup', function(){
    $(this).next().toggle('300');
});