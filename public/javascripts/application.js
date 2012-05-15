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

$("div.updates").live('click', function(){
   	$("#updateFeed").show();
   	$("#sumreqFeed").hide();
   	$("#mostViewedFeed").hide();
   	$(this).css('background', '#005997');
	$(this).css('color', '#fff');$("div.sumreqs").css('background', '#fff');
   	$("div.sumreqs").css('color', '#000');
  	$("div.most_viewed").css('background', '#fff');
	$("div.most_viewed").css('color', '#000');
});

$("div.sumreqs").live('click', function(){
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

$("div.most_viewed").live('click', function(){
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
$(".searchreset").live('click', function(){
	$(this).css('color', '#000');
	$(this).css('font-style', 'normal');	
});


//Abstract Expansion
$("#abstract").live('click', function(){
    	$("#abstract_short").hide();
    	$("#abstract_long").slideToggle(300);
});

//Quickform Expansion

$('a.quick_comment').click(function(){
	$('div.quick_question').hide(300);
	$('div.quick_comment').show(300);
});

$('a.quick_question').click(function(){
	$('div.quick_comment').hide(300);
	$('div.quick_question').show(300);
});


//Quickform Selection

$('.selectFig').live('click', function(){
	$(this).css('background-color', '#fff');
	$(this).css('font-weight', 'bold');	
	$(this).css('font-style', 'normal');
	$(this).parent().find('.selectPaper').css('font-style', 'italic');
	$(this).parent().find('.selectPaper').css('background-color', '#9FCF67');
	$(this).parent().find('.selectPaper').css('font-weight', 'normal');
});

$('.selectFig input').live('click', function(){
	$(this).css('color', '#000');
	$(this).css('font-style', 'normal');
});

$('.selectPaper').live('click', function(){
	$(this).css('background-color', '#fff');
	$(this).css('font-weight', 'bold');	
	$(this).css('font-style', 'normal');
	$(this).parent().find('.selectFig').css('font-style', 'italic');
	$(this).parent().find('.selectFig').css('background-color', '#9FCF67');
	$(this).parent().find('.selectFig').css('font-weight', 'normal');
	$(this).parent().find('.selectFig input').val('');
});

$(".quickform form").live('submit', function(){
	$.post($(this).attr("action"), $(this).serialize(), null, "script");
	$(this).html('Just a sec...');
	return false;
});

//Hide/Show Discussion Map (known as 'overview' in the code)
  $(".overview_open").live('click', function(){
	$(this).find('img').toggle();
    	$(this).next().slideToggle(300);
  });

//Share Expansion
  $("li.sharelink").live('click', function(){
    $("div.improve").hide("slow");
    $("div.commentbox").hide("slow");
    $("div.question").hide("slow");
    $(this).parent().parent().parent().find("div.sharebox").slideToggle(0);
  });

  $("div.share_button_top").live('click', function(){
    $(this).find("div.share_button_form").slideToggle(0);
  });


  $('div.share_form').find(':input').live('click', function(){
     if( $(this).val() == "Check this out!")
        $(this).val('');
     end
     });

//Toggle Figure sections
   $("div.figtoggle").live('click', function(){
     mpq.track("Sections expanded");
     $(this).next().toggle(300);
     $(this).find('img').toggle();
    });

//Reply box expansion
  $("li.replylink").live('click', function(){
      mpq.track("Reply box opened");
    $("div.answerform").hide("slow");
    $(this).parent().parent().parent().find("div.replyform").slideToggle(300);
    //$(this).html('It works!');
  });

//Answer box expansion
  $("nav li.answerlink").live('click', function(){
      mpq.track("Answer box opened");
    $("div.replyform").hide("slow");
    $(this).parent().parent().parent().find("div.answerform").slideToggle();
  });

//Image expansion
  
   $(".summary img.thumbnail").live('click', function(){
      mpq.track("Image expanded");
    $("div.improve").hide("slow");
    $("div.commentbox").hide("slow");
    $("div.questionbox").hide("slow");
    $("div.sharebox").hide("slow");
    $(this).parent().next().find("img.fullfig").slideToggle();
    });

//Class options expansion
   $("div#instructor_options").live('click', function(){
      mpq.track("Instructor options");
     $(this).hide();
     $('div.class_options').show();
   });

//Select # of figures and figsections expansion
    $("div.add_figs_and_sections").live('click', function(){
	mpq.track("Section menu expanded");
	$(this).parent().find('div.numselect').slideToggle();
	$(this).find('img').toggle();
     });

//Image upload for admins
    $(".fig_upload").live('click', function(){
      $(this).parent().find('div.upload_form').show();
     });

//Close when you click colored area on the right
//   $("td.sumleft").live('click', function(){
//    $("div.improve").hide("slow");
//    $("div.commentbox").hide("slow");
//    $("div.questionbox").hide("slow"); 
//    $("div.sharebox").hide("slow");
//    $("form.new_assertion").hide("slow");
//   $("form.enter_assertion").show("slow");
//    });

//Click to reveal a form.
   $(".editme").live('click', function(){
     $(this).hide();
     $(this).next().css('display', 'inline');
    });

//Show assertion history when editing
   $('div.latest_assertion.editme, p.method.editme').live('click', function(){
     $.post($(this).parent().find('form.improvelist').first().attr("action"), $(this).parent().find('form.improvelist').first().serialize(), null, "script");
    });

//Reset assertion forms when clicked.

   $("#assertion_text, #assertion_method_text").live('click', function(){
     if( $(this).val().substring(0,27) == "What is the core conclusion" || $(this).val() == "Separate methods with commas (e.g. western blot, QPCR, etc.)" || $(this).val() == "What are alternate approaches?")
        $(this).val('');

       });


//
//Dynamic Loading of Elements
//

//Load Summary Form
//$("form.enter_assertion").live('click', function(){
//$("form.enter_assertion").mouseover(function(){
//      $(this).hide();
//      mpq.track("Summary form called");
//      $.post($(this).attr("action"), $(this).serialize(), null, "script");
//      return false;
//    });


// Vote Button

   $("form#new_vote").live('click', function(){
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

// Forms to submit through jQuery
   $("form.commentlist").live('click', function(){
      mpq.track("Comments viewed");
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

   $("form.questionlist").live('click', function(){
      mpq.track("Questions viewed");
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

//   $("form.improvelist").live('submit', function(){
//      mpq.track("Improve viewed");
//      $.post($(this).attr("action"), $(this).serialize(), null, "script");
//      return false;
//    });

   $("div.share_form").find("form").live('click', function(){
      mpq.track("Item shared");
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

   $("div.sumreq_button").find("form").live('click', function(){
      mpq.track("Summary Requested");
      $.post($(this).attr("action"), $(this).serialize(), null, "script");
      return false;
    });

// Enter Assertion

   $("form.new_assertion, form.edit_assertion").live('submit', function(){
     mpq.track("Summary entered");
     $.post($(this).attr("action"), $(this).serialize(), null, "script");  
     return false;
    });


//
//Submit comment or question
//

   $("form.new_comment").live('submit', function(){
	mpq.track("Comment entered");
      	$.post($(this).attr("action"), $(this).serialize(), null, "script");
	$(this).html('Just a sec...');
      	return false;
    });

   $("form.new_question").live('submit', function(){
	mpq.track("Question entered");
      	$.post($(this).attr("action"), $(this).serialize(), null, "script");
	$(this).html('Just a sec...');
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

