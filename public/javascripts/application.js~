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
    $("form.enter_assertion").show("slow");
    });

//Toggle Figure sections
   $("td.figtoggle").toggle(function(){
     $(this).parent().parent().parent().next().show("slow");
     $("td.figtoggle", this).text("-");
     },function(){
     $(this).parent().parent().parent().next().hide("slow");
     $("td.figtoggle", this).text("+"); 
    });

//Reply box expansion
  $("div.commentbox nav").click(function(){
    $("div.answerform").hide("slow");
    $(this).parent().parent().parent().find("div.replyform").slideToggle();
    //$(this).html('It works!');
  });

//Answer box expansion
  $("nav li.answerlink").click(function(){
    $("div.replyform").hide("slow");
    $(this).parent().parent().parent().find("div.answerform").slideToggle();
  });

//Image expansion
  
   $("td.fig img").click(function(){
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

//Select # of figures and figsections expansion
    $("div.add_figs_and_sections h3").click(function(){
      $(this).parent().find('div.numselect').slideToggle();
     });

//Image upload for admins
    $(".fig_upload").click(function(){
      $(this).parent().find('div.upload_form').show();
     });


//
//Dynamic Loading of Elements
//

//Load Summary Form
  $("form.enter_assertion").mouseover(function(){
//Redundant code b/c testing can't do mouseover
//  $("form.enter_assertion").click(function(){
      $(this).hide();
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });


// Vote Button
   $("form#new_vote").submit(function(){
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

// Forms to submit through jQuery
   $("form.commentlist, form.questionlist").submit(function(){
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });



// Enter Assertion

   $("form.new_assertion").submit(function(){
     $.post($(this).attr("action"), $(this).serialize(), null, "script");  
      return false;
    });


//
//Styling
//

  $("div.fig_numselect, div.figsection_numselect").hover(function(){
      $(this).css('background', '#fff')},
      function(){
      $(this).css('background', 'none')
    });

   $('form.new_assertion').find(':input').click(function(){
     if( $(this).val().substring(0,27) == "What is the core conclusion" || $(this).val() == "What principal methods are used?" || $(this).val() == "What are alternate approaches?")
        $(this).val('');
     end
     });


});

