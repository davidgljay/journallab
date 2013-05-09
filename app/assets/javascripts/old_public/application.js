// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//Submit everything as Javascript
jQuery.ajaxSetup({
   'beforeend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});


$(document).ready(function(){


//Feed


$(document).on('click', ".loadingPrompt", function(){
	$(this).val("Just a sec..");
});

$(document).on('click', ".feedPlus", function(){
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
$(document).on('click', 'i.icon-remove', function(){
	$(this).parent().hide();
	$('div.overlay').hide();
});

//Abstract Expansion
$(document).on('click', "#abstract", function(){
    	$("#abstract_short").hide();
    	$("#abstract_long").slideToggle(300);
});

$(document).on('click', '.abstract', function(){
	$(this).parent().parent().find('.abstract_long').slideToggle(300);
});

$(document).on('click', '.list_abstract', function(){
	$(this).parent().parent().parent().find('.abstract_long').slideToggle(300);
});

//Citation expansion

$(document).on('click', '.citation_link', function(){
    	$(this).parent().parent().find('.citation').slideToggle(300);
});


//Blog post expansion
$("#blogs").find("h4").click(function(){
	$(this).next().slideToggle(300);
});




// Reveal reactions when clicking "Give your reaction"

$(document).on('click', '.leave_reaction', function() {
	$(this).hide();
	$(this).parent().parent().find('h5').toggle();
	$(this).parent().parent().find('.toggle').css('display', 'inline-block');
  });


//Hide/Show Discussion Map (known as 'overview' in the code)
  $(document).on('click', ".overview_open", function(){
	$(this).find('img').toggle();
    	$(this).next().slideToggle(300);
  });


    // Anonymity Lightbox
    $(document).on('click', ".anon_learn_more", function(){

        $(this).parent().next().toggle();
    });


//Toggle Figure sections
   $(document).on('click', "div.figtoggle", function(){
     $(this).next().toggle(300);
     $(this).find('img').toggle();
    });

//Reply box expansion
  $(document).on('click', "li.replylink", function(){
    $("div.answerform").hide("slow");
    $(this).parent().parent().parent().find("div.replyform").slideToggle(300);
    //$(this).html('It works!');
  });


//Image expansion
  
   $(document).on('click', ".summary img.thumbnail", function(){
    $(this).parent().next().find(".fullfig").slideToggle();
    });


//Select # of figures and figsections expansion
    $(document).on('click', "div.add_figs_and_sections", function(){
	$(this).parent().find('div.numselect').slideToggle();
	$(this).find('img').toggle();
     });

//Add/Remove figs in a paper
    $(document).on('click',"div#add_figs_link", function(){
	$(this).hide(300);
	$('div#add_figs').show(300);
     });	

//Image upload
    $(document).on('click', ".fig_upload", function(){
      $(this).parent().find('div.upload_form').show();
     });

//Click to reveal a form.
   $(document).on('click', ".editme", function(){
     $(this).hide();
     $(this).next().css('display', 'inline');
    });

//Show assertion history when editing
   $(document).on('click','div.latest_assertion.editme, p.method.editme', function(){
     $.post($(this).parent().find('form.improvelist').first().attr("action"), $(this).parent().find('form.improvelist').first().serialize(), null, "script");
    });

//Reset assertion forms when clicked.

   $(document).on('click',"#assertion_text, #assertion_method_text", function(){
     if( $(this).val().substring(0,20) == "What are the authors" || $(this).val() == "Separate methods with commas (e.g. western blot, QPCR, etc.)" || $(this).val() == "What are alternate approaches?" || $(this).val() == "Please provide a brief summary of this paper readable to a scientist outside of this field."  || $(this).val().substring(0,27) == "What are alternate approaches?")
        $(this).val('');

       });

$(document).on('click', '#expandSignup', function(){
	$('#signup').toggle('300');
});

//
// Reload the page if you get an error from a JS call
//

$('body').bind("ajax:error", function(event, data, status, xhr) {
    location.reload();
});



// Folder prompt when not signed in
$(document).on('click', '.folderAdd', function(){
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

