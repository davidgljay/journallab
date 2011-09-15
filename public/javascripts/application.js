// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  $("#abstract").click(function(){
    $("#abstract_short").hide();
    $("#abstract_long").slideToggle('medium');
  });

  $("div.enter_assertion").mouseover(function(){
    $("h5", this).hide("med");
    $("form.new_assertion", this).show("med");
  });

  $("nav li.improvelink").click(function(){
    $("div.commentbox").hide("slow");
    $("div.questionbox").hide("slow");
    $(this).parent().parent().parent().find("form.new_assertion").show();
    $(this).parent().parent().parent().find("div.improve").slideToggle();
  });

  $("nav li.commentlink").click(function(){
    $("div.improve").hide("slow");
    $("div.questionbox").hide("slow");
    $(this).parent().parent().parent().find("div.commentbox").slideToggle();
  });

  $("nav li.questionlink").click(function(){
    $("div.improve").hide("slow");
    $("div.commentbox").hide("slow");
    $(this).parent().parent().parent().find("div.questionbox").slideToggle();
  });

});
