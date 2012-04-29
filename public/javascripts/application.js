// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//Submit everything as Javascript
jQuery.ajaxSetup({
   'beforeend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

$(document).ready(function(){

//Feed

 
 $("div.updates").css('background', '#005997');
 $("div.updates").css('color', '#fff');

 $("div.updates").click(function(){
   	$("#updateFeed").show();
   	$("#sumreqFeed").hide();
   	$("#mostViewedFeed").hide();
   	$(this).css('background', '#005997');
	$(this).css('color', '#fff');$("div.sumreqs").css('background', '#fff');
   	$("div.sumreqs").css('color', '#000');
  	$("div.most_viewed").css('background', '#fff');
	$("div.most_viewed").css('color', '#000');
});

$("div.sumreqs").click(function(){
   	$("#updateFeed").hide();
   	$("#sumreqFeed").show();
   	$("#mostViewedFeed").hide();
   	$(this).css('background', '#005997');
   	$(this).css('color', '#fff');
   	$("div.updates").css('background', '#fff');
	$("div.updates").css('color', '#000');
   	$("div.most_viewed").css('background', '#fff');
   	$("div.most_viewed").css('color', '#000');
});

$("div.most_viewed").click(function(){
	$("#updateFeed").hide();
	$("#sumreqFeed").hide();
	$("#mostViewedFeed").show();
	$(this).css('background', '#005997');
	$(this).css('color', '#fff');
	$("div.updates").css('background', '#fff');
	$("div.updates").css('color', '#000');
	$("div.sumreqs").css('background', '#fff');
	$("div.sumreqs").css('color', '#000');
});

//Search
$(".inputSearch").click(function(){
	$(this).css('font-size', '14px');
	$(this).css('color', '#000');
	$(this).css('font-style', 'normal');	
});


//Abstract Expansion
  $("#abstract").click(function(){
    $("#abstract_short").hide();
    $("#abstract_long").slideToggle('medium');
  });

//Hide/Show Discussion Map (known as 'overview' in the code)
  $(".overview_open").click(function(){
	$(this).find('img').toggle();
    	$(this).next().slideToggle('slow');
  });

//Share Expansion
  $("li.sharelink").click(function(){
    $("div.improve").hide("slow");
    $("div.commentbox").hide("slow");
    $("div.question").hide("slow");
    $(this).parent().parent().parent().find("div.sharebox").slideToggle(0);
  });

  $("div.share_button_top").click(function(){
    $(this).find("div.share_button_form").slideToggle(0);
  });


  $('div.share_form').find(':input').click(function(){
     if( $(this).val() == "Check this out!")
        $(this).val('');
     end
     });

//Toggle Figure sections
   $("div.figtoggle").click(function(){
     mpq.track("Sections expanded");
     $(this).next().toggle('fast');
     $(this).find('img').toggle();
    });

//Reply box expansion
  $("div.commentbox nav").click(function(){
      mpq.track("Reply box opened");
    $("div.answerform").hide("slow");
    $(this).parent().parent().parent().find("div.replyform").slideToggle('fast');
    //$(this).html('It works!');
  });

//Answer box expansion
  $("nav li.answerlink").click(function(){
      mpq.track("Answer box opened");
    $("div.replyform").hide("slow");
    $(this).parent().parent().parent().find("div.answerform").slideToggle();
  });

//Image expansion
  
   $(".summary img.thumbnail").click(function(){
      mpq.track("Image expanded");
    $("div.improve").hide("slow");
    $("div.commentbox").hide("slow");
    $("div.questionbox").hide("slow");
    $("div.sharebox").hide("slow");
    $(this).parent().next().find("img.fullfig").slideToggle();
    });

//Class options expansion
   $("div#instructor_options").click(function(){
      mpq.track("Instructor options");
     $(this).hide();
     $('div.class_options').show();
   });

//Select # of figures and figsections expansion
    $("div.add_figs_and_sections").click(function(){
	mpq.track("Section menu expanded");
	$(this).parent().find('div.numselect').slideToggle();
	$(this).find('img').toggle();
     });

//Image upload for admins
    $(".fig_upload").click(function(){
      $(this).parent().find('div.upload_form').show();
     });

//Close when you click colored area on the right
//   $("td.sumleft").click(function(){
//    $("div.improve").hide("slow");
//    $("div.commentbox").hide("slow");
//    $("div.questionbox").hide("slow"); 
//    $("div.sharebox").hide("slow");
//    $("form.new_assertion").hide("slow");
//   $("form.enter_assertion").show("slow");
//    });

//Click to reveal a form.
   $(".editme").click(function(){
     $(this).hide();
     $(this).next().css('display', 'inline');
    });

//Show assertion history when editing
   $('div.latest_assertion.editme, p.method.editme').click(function(){
     $.post($(this).parent().find('form.improvelist').first().attr("action"), $(this).parent().find('form.improvelist').first().serialize(), null, "script");
    });

//Reset assertion forms when clicked.

   $("form.new_assertion, form.edit_assertion").find(':input').click(function(){
     if( $(this).val().substring(0,27) == "What is the core conclusion" || $(this).val() == "Separate methods with commas, e.g. western blot, QPCR" || $(this).val() == "What are alternate approaches?")
        $(this).val('');
     });


//
//Dynamic Loading of Elements
//

//Load Summary Form
//$("form.enter_assertion").click(function(){
//$("form.enter_assertion").mouseover(function(){
//      $(this).hide();
//      mpq.track("Summary form called");
//      $.post($(this).attr("action"), $(this).serialize(), null, "script");
//      return false;
//    });


// Vote Button

   $("form#new_vote").click(function(){
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

// Forms to submit through jQuery
   $("form.commentlist").click(function(){
      mpq.track("Comments viewed");
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

   $("form.questionlist").click(function(){
      mpq.track("Questions viewed");
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

//   $("form.improvelist").submit(function(){
//      mpq.track("Improve viewed");
//      $.post($(this).attr("action"), $(this).serialize(), null, "script");
//      return false;
//    });

   $("div.share_form").find("form").click(function(){
      mpq.track("Item shared");
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

   $("div.sumreq_button").find("form").submit(function(){
      mpq.track("Summary Requested");
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

// Enter Assertion

   $("form.new_assertion, form.edit_assertion").submit(function(){
     mpq.track("Summary entered");
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



});

