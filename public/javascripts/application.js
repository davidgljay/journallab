// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//Submit everything as Javascript
jQuery.ajaxSetup({
   'beforeend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});


//Paper Detail Page
$(document).ready(function(){
  $("#abstract").click(function(){
    $("#abstract_short").hide();
    $("#abstract_long").slideToggle('medium');
  });

//Enter Assertion
  $("div.enter_assertion").hover(function(){
    $("h5", this).slideToggle("med");
    $("form.new_assertion", this).slideToggle("med");
  });

//Improve Expansion
  $("nav li.improvelink").click(function(){
    $("div.commentbox").hide("slow");
    $("div.questionbox").hide("slow");
    $(this).parent().parent().parent().find("form.new_assertion").show();
    $(this).parent().parent().parent().find("div.improve").slideToggle();
  });

//Comment Expansion
//  $("nav li.commentlink").click(function(){
//    $("div.improve").hide("slow");
//    $("div.questionbox").hide("slow");
//    $(this).parent().parent().parent().find("div.commentbox").slideToggle();
//  });

//Question Expansion
//  $("nav li.questionlink").click(function(){
//    $("div.improve").hide("slow");
//    $("div.commentbox").hide("slow");
//    $(this).parent().parent().parent().find("div.questionbox").slideToggle();
//  });

//Close when you click colored area on the right
   $("td.sumleft").click(function(){
    $("div.improve").hide("slow");
    $("div.commentbox").hide("slow");
    $("div.questionbox").hide("slow"); 
    $("form.new_assertion").hide("slow");
    $("h5").show("slow");
    });

//Toggle Figure sections
   $("td.figtoggle, td.sumleft.fig").toggle(function(){
     $(this).parent().parent().parent().next().show("slow");
     $("td.figtoggle", this).text("-");
     },function(){
     $(this).parent().parent().parent().next().hide("slow");
     $("td.figtoggle", this).text("+"); 
    });

//Reply box expansion
  $("div.commentbox nav").click(function(){
    //$("div.answerform").hide("slow");
    //$(this).parent().parent().parent().find("div.replyform").slideToggle();
    $(this).html('It works!');
  });

//Answer box expansion
  $("nav li.answerlink").click(function(){
    $("div.replyform").hide("slow");
    $(this).parent().parent().parent().find("div.answerform").slideToggle();
  });

//Image expansion
  
   $("td.sumleft img").click(function(){
    $("div.improve").hide("slow");
    $("div.commentbox").hide("slow");
    $("div.questionbox").hide("slow");
    $(this).parent().next().find("img.fullfig").slideToggle();
    });

//Class options expansion
   $("div#instructor_options").click(function(){
     $(this).hide();
     $('div.class_options').show();
   });

//
//Dynamic Loading of Elements
//

// Vote Button
   $("form#new_vote").submit(function(){
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

// Add Comments Button
   $("form.commentlist, form.questionlist").submit(function(){
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

});
