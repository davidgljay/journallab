// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//Submit everything as Javascript
jQuery.ajaxSetup({
   'beforeend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});


$(document).ready(function(){


//Feed


$(".loadingPrompt").on('click', function(){
	$(this).val("Just a sec..");
});

$(".feedPlus").on('click', function(){
	$('div').removeClass('feed_nav_selected');
	$(this).addClass('feed_nav_selected');
	$('.homePageFeed').hide();
	$('#follow_form').show();
	$('.feed_remove').css('display','inline-block');
});



//Search
$(".searchreset").on('click', function(){
	$(this).css('color', '#000');
	$(this).css('font-style', 'normal');	
});

//Overlay Close
$(".lightbox").find("i.icon-remove").on('click', function(){
	$(this).parent().hide();
	$('div.overlay').hide();
});

//Abstract Expansion
$("#abstract").on('click', function(){
    	$("#abstract_short").hide();
    	$("#abstract_long").slideToggle(300);
});

$(".abstract").on('click', function(){
	$(this).parent().parent().find('.abstract_long').slideToggle(300);
});

$(".list_abstract").on('click', function(){
	$(this).parent().parent().parent().find('.abstract_long').slideToggle(300);
});

//Citation expansion

$(".citation_link").on('click', function(){
    	$(this).parent().parent().find('.citation').slideToggle(300);
});


//Blog post expansion
$("#blogs").find("h4").click(function(){
	$(this).next().slideToggle(300);
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


$('.quickform input').on('click', function(){
	$(this).css('color', '#000');
	$(this).css('font-style', 'normal');
});


$(".quickform form").on('submit', function(){
	$(this).parent().hide();
	$(this).parent().next().show();
});

// Reveal reactions when clicking "Give your reaction"

$(".leave_reaction").on('click', function() {
	$(this).hide();
	$(this).parent().parent().find('h5').toggle();
	$(this).parent().parent().find('.toggle').css('display', 'inline-block');
  });


//Hide/Show Discussion Map (known as 'overview' in the code)
  $(".overview_open").on('click', function(){
	$(this).find('img').toggle();
    	$(this).next().slideToggle(300);
  });

//Share Expansion
  $(".sharelink").on('click', function(){
    $(this).parent().parent().parent().find("div.sharebox").show();

  });

  $("div.share_button_text").on('click', function(){
    $(this).parent().find("div.share_button_form").show();
    $('div.overlay').show('');
  });


  $('div.share_form').find(':input').on('click', function(){
     if( $(this).val() == "Check this out!"){
        $(this).val('');
     }
     });


//Share Feed

//   $('#shareFeedLink').click(function(){
//	$('div#shareFeed').toggle('300');
//	$(this).find('div.badge').hide();
//     });


    // Anonymity Lightbox
    $(".anon_learn_more").on('click', function(){

        $(this).parent().next().toggle();
    });


//Toggle Figure sections
   $("div.figtoggle").on('click', function(){
     $(this).next().toggle(300);
     $(this).find('img').toggle();
    });

//Reply box expansion
  $("li.replylink").on('click', function(){
    $("div.answerform").hide("slow");
    $(this).parent().parent().parent().find("div.replyform").slideToggle(300);
    //$(this).html('It works!');
  });

//Answer box expansion
  $("nav li.answerlink").on('click', function(){
    $("div.replyform").hide("slow");
    $(this).parent().parent().parent().find("div.answerform").slideToggle();
  });

//Image expansion
  
   $(".summary img.thumbnail").on('click', function(){
    $(this).parent().next().find(".fullfig").slideToggle();
    });


//Select # of figures and figsections expansion
    $("div.add_figs_and_sections").on('click', function(){
	$(this).parent().find('div.numselect').slideToggle();
	$(this).find('img').toggle();
     });

//Add/Remove figs in a paper
    $("div#add_figs_link").on('click', function(){
	$(this).hide(300);
	$('div#add_figs').show(300);
     });	

//Image upload
    $(".fig_upload").on('click', function(){
      $(this).parent().find('div.upload_form').show();
     });

//Click to reveal a form.
   $(".editme").on('click', function(){
     $(this).hide();
     $(this).next().css('display', 'inline');
    });

//Show assertion history when editing
   $('div.latest_assertion.editme, p.method.editme').on('click', function(){
     $.post($(this).parent().find('form.improvelist').first().attr("action"), $(this).parent().find('form.improvelist').first().serialize(), null, "script");
    });

//Reset assertion forms when clicked.

   $("#assertion_text, #assertion_method_text").on('click', function(){
     if( $(this).val().substring(0,20) == "What are the authors" || $(this).val() == "Separate methods with commas (e.g. western blot, QPCR, etc.)" || $(this).val() == "What are alternate approaches?" || $(this).val() == "Please provide a brief summary of this paper readable to a scientist outside of this field."  || $(this).val().substring(0,27) == "What are alternate approaches?")
        $(this).val('');

       });

$('#expandSignup').click(function(){
	$('#signup').toggle('300');
});

//
// Reload the page if you get an error from a JS call
//

$('body').bind("ajax:error", function(event, data, status, xhr) {
    location.reload();
});


// Dropdown menus

$('.dropdown-toggle').on('click', function(){
	$(this).next().toggle('300');
});

// Folder prompt when not signed in
$('.folderAdd').on('click', function(){
    $(this).next().toggle();

});

// Carousel

			$('#slides').slides({
				preload: true,
				preloadImage: 'assets/loading.gif',
				play: 9000,
				pause: 2500,
				hoverPause: true,
				animationStart: function(current){
					$('.caption').animate({
						bottom:-35
					},100);
					if (window.console && console.log) {
						// example return of current slide number
						console.log('animationStart on slide: ', current);
					};
				},
				animationComplete: function(current){
					$('.caption').animate({
						bottom:0
					},200);
					if (window.console && console.log) {
						// example return of current slide number
						console.log('animationComplete on slide: ', current);
					};
				},
				slidesLoaded: function() {
					$('.caption').animate({
						bottom:0
					},200);
				}
			});

//
//Styling
//

  $("div.fig_numselect, div.figsection_numselect").hover(function(){
      $(this).css('background', '#fff')},
      function(){
      $(this).css('background', 'none')
    });

   $(".deadLink").on('click', function(e){
	e.preventDefault();
	return false;
    });

$('.flash').delay('5000').fadeOut('slow');




});

