// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$('.popup').live('click', function(){
    $(this).next().toggle('300');
});