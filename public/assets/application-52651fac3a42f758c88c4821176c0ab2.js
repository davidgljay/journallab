// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(".popup").live("click",function(){$(this).next().toggle("300")}),jQuery.ajaxSetup({beforeend:function(e){e.setRequestHeader("Accept","text/javascript")}}),$(document).ready(function(){$(".loadingPrompt").live("click",function(){$(this).val("Just a sec..")}),$(".feedPlus").live("click",function(){$("div").removeClass("feed_nav_selected"),$(this).addClass("feed_nav_selected"),$(".homePageFeed").hide(),$("#follow_form").show(),$(".feed_remove").css("display","inline-block")}),$(".searchreset").live("click",function(){$(this).css("color","#000"),$(this).css("font-style","normal")}),$(".lightbox").find("i.icon-remove").live("click",function(){$(this).parent().hide(),$("div.overlay").hide()}),$("#abstract").live("click",function(){$("#abstract_short").hide(),$("#abstract_long").slideToggle(300)}),$(".abstract").live("click",function(){$(this).parent().parent().find(".abstract_long").slideToggle(300)}),$(".list_abstract").live("click",function(){$(this).parent().parent().parent().find(".abstract_long").slideToggle(300)}),$(".citation_link").live("click",function(){$(this).parent().parent().find(".citation").slideToggle(300)}),$("#blogs").find("h4").click(function(){$(this).next().slideToggle(300)}),$("a.quick_comment").click(function(){$("div.quick_question").hide(300),$("div.quick_comment").show(300)}),$("a.quick_question").click(function(){$("div.quick_comment").hide(300),$("div.quick_question").show(300)}),$(".quickform input").live("click",function(){$(this).css("color","#000"),$(this).css("font-style","normal")}),$(".quickform form").live("submit",function(){$(this).parent().hide(),$(this).parent().next().show()}),$(".leave_reaction").live("click",function(){$(this).hide(),$(this).parent().parent().find("h5").toggle(),$(this).parent().parent().find(".toggle").css("display","inline-block")}),$(".overview_open").live("click",function(){$(this).find("img").toggle(),$(this).next().slideToggle(300)}),$(".sharelink").live("click",function(){$(this).parent().parent().parent().find("div.sharebox").show()}),$("div.share_button_text").live("click",function(){$(this).parent().find("div.share_button_form").show(),$("div.overlay").show("")}),$("div.share_form").find(":input").live("click",function(){$(this).val()=="Check this out!"&&$(this).val("")}),$(".anon_learn_more").live("click",function(){$(this).parent().next().toggle()}),$("div.figtoggle").live("click",function(){$(this).next().toggle(300),$(this).find("img").toggle()}),$("li.replylink").live("click",function(){$("div.answerform").hide("slow"),$(this).parent().parent().parent().find("div.replyform").slideToggle(300)}),$("nav li.answerlink").live("click",function(){$("div.replyform").hide("slow"),$(this).parent().parent().parent().find("div.answerform").slideToggle()}),$(".summary img.thumbnail").live("click",function(){$(this).parent().next().find(".fullfig").slideToggle()}),$("div.add_figs_and_sections").live("click",function(){$(this).parent().find("div.numselect").slideToggle(),$(this).find("img").toggle()}),$("div#add_figs_link").live("click",function(){$(this).hide(300),$("div#add_figs").show(300)}),$(".fig_upload").live("click",function(){$(this).parent().find("div.upload_form").show()}),$(".editme").live("click",function(){$(this).hide(),$(this).next().css("display","inline")}),$("div.latest_assertion.editme, p.method.editme").live("click",function(){$.post($(this).parent().find("form.improvelist").first().attr("action"),$(this).parent().find("form.improvelist").first().serialize(),null,"script")}),$("#assertion_text, #assertion_method_text").live("click",function(){($(this).val().substring(0,20)=="What are the authors"||$(this).val()=="Separate methods with commas (e.g. western blot, QPCR, etc.)"||$(this).val()=="What are alternate approaches?"||$(this).val()=="Please provide a brief summary of this paper readable to a scientist outside of this field."||$(this).val().substring(0,27)=="What are alternate approaches?")&&$(this).val("")}),$("#expandSignup").click(function(){$("#signup").toggle("300")}),$("body").bind("ajax:error",function(e,t,n,r){location.reload()}),$(".dropdown-toggle").live("click",function(){$(this).next().toggle("300")}),$(".folderAdd").live("click",function(){$(this).next().toggle()}),$("#slides").slides({preload:!0,preloadImage:"assets/loading.gif",play:9e3,pause:2500,hoverPause:!0,animationStart:function(e){$(".caption").animate({bottom:-35},100),window.console&&console.log&&console.log("animationStart on slide: ",e)},animationComplete:function(e){$(".caption").animate({bottom:0},200),window.console&&console.log&&console.log("animationComplete on slide: ",e)},slidesLoaded:function(){$(".caption").animate({bottom:0},200)}}),$("div.fig_numselect, div.figsection_numselect").hover(function(){$(this).css("background","#fff")},function(){$(this).css("background","none")}),$(".deadLink").live("click",function(e){return e.preventDefault(),!1}),$(".flash").delay("5000").fadeOut("slow")}),function(e,t){var n;e.rails=n={linkClickSelector:"a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]",inputChangeSelector:"select[data-remote], input[data-remote], textarea[data-remote]",formSubmitSelector:"form",formInputClickSelector:"form input[type=submit], form input[type=image], form button[type=submit], form button:not(button[type])",disableSelector:"input[data-disable-with], button[data-disable-with], textarea[data-disable-with]",enableSelector:"input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled",requiredInputSelector:"input[name][required]:not([disabled]),textarea[name][required]:not([disabled])",fileInputSelector:"input:file",linkDisableSelector:"a[data-disable-with]",CSRFProtection:function(t){var n=e('meta[name="csrf-token"]').attr("content");n&&t.setRequestHeader("X-CSRF-Token",n)},fire:function(t,n,r){var i=e.Event(n);return t.trigger(i,r),i.result!==!1},confirm:function(e){return confirm(e)},ajax:function(t){return e.ajax(t)},href:function(e){return e.attr("href")},handleRemote:function(r){var i,s,o,u,a,f;if(n.fire(r,"ajax:before")){u=r.data("cross-domain")||null,a=r.data("type")||e.ajaxSettings&&e.ajaxSettings.dataType;if(r.is("form")){i=r.attr("method"),s=r.attr("action"),o=r.serializeArray();var l=r.data("ujs:submit-button");l&&(o.push(l),r.data("ujs:submit-button",null))}else r.is(n.inputChangeSelector)?(i=r.data("method"),s=r.data("url"),o=r.serialize(),r.data("params")&&(o=o+"&"+r.data("params"))):(i=r.data("method"),s=n.href(r),o=r.data("params")||null);return f={type:i||"GET",data:o,dataType:a,crossDomain:u,beforeSend:function(e,i){return i.dataType===t&&e.setRequestHeader("accept","*/*;q=0.5, "+i.accepts.script),n.fire(r,"ajax:beforeSend",[e,i])},success:function(e,t,n){r.trigger("ajax:success",[e,t,n])},complete:function(e,t){r.trigger("ajax:complete",[e,t])},error:function(e,t,n){r.trigger("ajax:error",[e,t,n])}},s&&(f.url=s),n.ajax(f)}return!1},handleMethod:function(r){var i=n.href(r),s=r.data("method"),o=r.attr("target"),u=e("meta[name=csrf-token]").attr("content"),a=e("meta[name=csrf-param]").attr("content"),f=e('<form method="post" action="'+i+'"></form>'),l='<input name="_method" value="'+s+'" type="hidden" />';a!==t&&u!==t&&(l+='<input name="'+a+'" value="'+u+'" type="hidden" />'),o&&f.attr("target",o),f.hide().append(l).appendTo("body"),f.submit()},disableFormElements:function(t){t.find(n.disableSelector).each(function(){var t=e(this),n=t.is("button")?"html":"val";t.data("ujs:enable-with",t[n]()),t[n](t.data("disable-with")),t.prop("disabled",!0)})},enableFormElements:function(t){t.find(n.enableSelector).each(function(){var t=e(this),n=t.is("button")?"html":"val";t.data("ujs:enable-with")&&t[n](t.data("ujs:enable-with")),t.prop("disabled",!1)})},allowAction:function(e){var t=e.data("confirm"),r=!1,i;return t?(n.fire(e,"confirm")&&(r=n.confirm(t),i=n.fire(e,"confirm:complete",[r])),r&&i):!0},blankInputs:function(t,n,r){var i=e(),s,o=n||"input,textarea";return t.find(o).each(function(){s=e(this);if(r?s.val():!s.val())i=i.add(s)}),i.length?i:!1},nonBlankInputs:function(e,t){return n.blankInputs(e,t,!0)},stopEverything:function(t){return e(t.target).trigger("ujs:everythingStopped"),t.stopImmediatePropagation(),!1},callFormSubmitBindings:function(n,r){var i=n.data("events"),s=!0;return i!==t&&i.submit!==t&&e.each(i.submit,function(e,t){if(typeof t.handler=="function")return s=t.handler(r)}),s},disableElement:function(e){e.data("ujs:enable-with",e.html()),e.html(e.data("disable-with")),e.bind("click.railsDisable",function(e){return n.stopEverything(e)})},enableElement:function(e){e.data("ujs:enable-with")!==t&&(e.html(e.data("ujs:enable-with")),e.data("ujs:enable-with",!1)),e.unbind("click.railsDisable")}},e.ajaxPrefilter(function(e,t,r){e.crossDomain||n.CSRFProtection(r)}),e(document).delegate(n.linkDisableSelector,"ajax:complete",function(){n.enableElement(e(this))}),e(document).delegate(n.linkClickSelector,"click.rails",function(r){var i=e(this),s=i.data("method"),o=i.data("params");if(!n.allowAction(i))return n.stopEverything(r);i.is(n.linkDisableSelector)&&n.disableElement(i);if(i.data("remote")!==t)return(r.metaKey||r.ctrlKey)&&(!s||s==="GET")&&!o?!0:(n.handleRemote(i)===!1&&n.enableElement(i),!1);if(i.data("method"))return n.handleMethod(i),!1}),e(document).delegate(n.inputChangeSelector,"change.rails",function(t){var r=e(this);return n.allowAction(r)?(n.handleRemote(r),!1):n.stopEverything(t)}),e(document).delegate(n.formSubmitSelector,"submit.rails",function(r){var i=e(this),s=i.data("remote")!==t,o=n.blankInputs(i,n.requiredInputSelector),u=n.nonBlankInputs(i,n.fileInputSelector);if(!n.allowAction(i))return n.stopEverything(r);if(o&&i.attr("novalidate")==t&&n.fire(i,"ajax:aborted:required",[o]))return n.stopEverything(r);if(s)return u?n.fire(i,"ajax:aborted:file",[u]):!e.support.submitBubbles&&e().jquery<"1.7"&&n.callFormSubmitBindings(i,r)===!1?n.stopEverything(r):(n.handleRemote(i),!1);setTimeout(function(){n.disableFormElements(i)},13)}),e(document).delegate(n.formInputClickSelector,"click.rails",function(t){var r=e(this);if(!n.allowAction(r))return n.stopEverything(t);var i=r.attr("name"),s=i?{name:i,value:r.val()}:null;r.closest("form").data("ujs:submit-button",s)}),e(document).delegate(n.formSubmitSelector,"ajax:beforeSend.rails",function(t){this==t.target&&n.disableFormElements(e(this))}),e(document).delegate(n.formSubmitSelector,"ajax:complete.rails",function(t){this==t.target&&n.enableFormElements(e(this))}),e(function(){csrf_token=e("meta[name=csrf-token]").attr("content"),csrf_param=e("meta[name=csrf-param]").attr("content"),e('form input[name="'+csrf_param+'"]').val(csrf_token)})}(jQuery),function(e){e.fn.slides=function(t){return t=e.extend({},e.fn.slides.option,t),this.each(function(){function S(o,u,a){if(!v&&d){v=!0,t.animationStart(p+1);switch(o){case"next":c=p,l=p+1,l=i===l?0:l,g=s*2,o=-s*2,p=l;break;case"prev":c=p,l=p-1,l=l===-1?i-1:l,g=0,o=0,p=l;break;case"pagination":l=parseInt(a,10),c=e("."+t.paginationClass+" li."+t.currentClass+" a",n).attr("href").match("[^#/]+$"),l>c?(g=s*2,o=-s*2):(g=0,o=0),p=l}u==="fade"?t.crossfade?r.children(":eq("+l+")",n).css({zIndex:10}).fadeIn(t.fadeSpeed,t.fadeEasing,function(){t.autoHeight?r.animate({height:r.children(":eq("+l+")",n).outerHeight()},t.autoHeightSpeed,function(){r.children(":eq("+c+")",n).css({display:"none",zIndex:0}),r.children(":eq("+l+")",n).css({zIndex:0}),t.animationComplete(l+1),v=!1}):(r.children(":eq("+c+")",n).css({display:"none",zIndex:0}),r.children(":eq("+l+")",n).css({zIndex:0}),t.animationComplete(l+1),v=!1)}):r.children(":eq("+c+")",n).fadeOut(t.fadeSpeed,t.fadeEasing,function(){t.autoHeight?r.animate({height:r.children(":eq("+l+")",n).outerHeight()},t.autoHeightSpeed,function(){r.children(":eq("+l+")",n).fadeIn(t.fadeSpeed,t.fadeEasing)}):r.children(":eq("+l+")",n).fadeIn(t.fadeSpeed,t.fadeEasing,function(){e.browser.msie&&e(this).get(0).style.removeAttribute("filter")}),t.animationComplete(l+1),v=!1}):(r.children(":eq("+l+")").css({left:g,display:"block"}),t.autoHeight?r.animate({left:o,height:r.children(":eq("+l+")").outerHeight()},t.slideSpeed,t.slideEasing,function(){r.css({left:-s}),r.children(":eq("+l+")").css({left:s,zIndex:5}),r.children(":eq("+c+")").css({left:s,display:"none",zIndex:0}),t.animationComplete(l+1),v=!1}):r.animate({left:o},t.slideSpeed,t.slideEasing,function(){r.css({left:-s}),r.children(":eq("+l+")").css({left:s,zIndex:5}),r.children(":eq("+c+")").css({left:s,display:"none",zIndex:0}),t.animationComplete(l+1),v=!1})),t.pagination&&(e("."+t.paginationClass+" li."+t.currentClass,n).removeClass(t.currentClass),e("."+t.paginationClass+" li:eq("+l+")",n).addClass(t.currentClass))}}function x(){clearInterval(n.data("interval"))}function T(){t.pause?(clearTimeout(n.data("pause")),clearInterval(n.data("interval")),w=setTimeout(function(){clearTimeout(n.data("pause")),E=setInterval(function(){S("next",a)},t.play),n.data("interval",E)},t.pause),n.data("pause",w)):x()}e("."+t.container,e(this)).children().wrapAll('<div class="slides_control"/>');var n=e(this),r=e(".slides_control",n),i=r.children().size(),s=r.children().outerWidth(),o=r.children().outerHeight(),u=t.start-1,a=t.effect.indexOf(",")<0?t.effect:t.effect.replace(" ","").split(",")[0],f=t.effect.indexOf(",")<0?a:t.effect.replace(" ","").split(",")[1],l=0,c=0,h=0,p=0,d,v,m,g,y,b,w,E;if(i<2)return e("."+t.container,e(this)).fadeIn(t.fadeSpeed,t.fadeEasing,function(){d=!0,t.slidesLoaded()}),e("."+t.next+", ."+t.prev).fadeOut(0),!1;if(i<2)return;u<0&&(u=0),u>i&&(u=i-1),t.start&&(p=u),t.randomize&&r.randomize(),e("."+t.container,n).css({overflow:"hidden",position:"relative"}),r.children().css({position:"absolute",top:0,left:r.children().outerWidth(),zIndex:0,display:"none"}),r.css({position:"relative",width:s*3,height:o,left:-s}),e("."+t.container,n).css({display:"block"}),t.autoHeight&&(r.children().css({height:"auto"}),r.animate({height:r.children(":eq("+u+")").outerHeight()},t.autoHeightSpeed));if(t.preload&&r.find("img:eq("+u+")").length){e("."+t.container,n).css({background:"url("+t.preloadImage+") no-repeat 50% 50%"});var N=r.find("img:eq("+u+")").attr("src")+"?"+(new Date).getTime();e("img",n).parent().attr("class")!="slides_control"?b=r.children(":eq(0)")[0].tagName.toLowerCase():b=r.find("img:eq("+u+")"),r.find("img:eq("+u+")").attr("src",N).load(function(){r.find(b+":eq("+u+")").fadeIn(t.fadeSpeed,t.fadeEasing,function(){e(this).css({zIndex:5}),e("."+t.container,n).css({background:""}),d=!0,t.slidesLoaded()})})}else r.children(":eq("+u+")").fadeIn(t.fadeSpeed,t.fadeEasing,function(){d=!0,t.slidesLoaded()});t.bigTarget&&(r.children().css({cursor:"pointer"}),r.children().live("click",function(){return S("next",a),!1})),t.hoverPause&&t.play&&(r.bind("mouseover",function(){x()}),r.bind("mouseleave",function(){T()})),t.generateNextPrev&&(e("."+t.container,n).after('<a href="#" class="'+t.prev+'">Prev</a>'),e("."+t.prev,n).after('<a href="#" class="'+t.next+'">Next</a>')),e("."+t.next,n).live("click",function(e){e.preventDefault(),t.play&&T(),S("next",a)}),e("."+t.prev,n).live("click",function(e){e.preventDefault(),t.play&&T(),S("prev",a)}),t.generatePagination?(t.prependPagination?n.prepend("<ul class="+t.paginationClass+"></ul>"):n.append("<ul class="+t.paginationClass+"></ul>"),r.children().each(function(){e("."+t.paginationClass,n).append('<li><a href="#'+h+'">'+(h+1)+"</a></li>"),h++})):e("."+t.paginationClass+" li a",n).each(function(){e(this).attr("href","#"+h),h++}),e("."+t.paginationClass+" li:eq("+u+")",n).addClass(t.currentClass),e("."+t.paginationClass+" li a",n).live("click",function(){return t.play&&T(),m=e(this).attr("href").match("[^#/]+$"),p!=m&&S("pagination",f,m),!1}),e("a.link",n).live("click",function(){return t.play&&T(),m=e(this).attr("href").match("[^#/]+$")-1,p!=m&&S("pagination",f,m),!1}),t.play&&(E=setInterval(function(){S("next",a)},t.play),n.data("interval",E))})},e.fn.slides.option={preload:!1,preloadImage:"/assets/loading.gif",container:"slides_container",generateNextPrev:!1,next:"next",prev:"prev",pagination:!0,generatePagination:!0,prependPagination:!1,paginationClass:"slideshow_pagination",currentClass:"current",fadeSpeed:350,fadeEasing:"",slideSpeed:350,slideEasing:"",start:1,effect:"slide",crossfade:!1,randomize:!1,play:0,pause:0,hoverPause:!1,autoHeight:!1,autoHeightSpeed:350,bigTarget:!1,animationStart:function(){},animationComplete:function(){},slidesLoaded:function(){}},e.fn.randomize=function(t){function n(){return Math.round(Math.random())-.5}return e(this).each(function(){var r=e(this),s=r.children(),o=s.length;if(o>1){s.hide();var u=[];for(i=0;i<o;i++)u[u.length]=i;u=u.sort(n),e.each(u,function(e,n){var i=s.eq(n),o=i.clone(!0);o.show().appendTo(r),t!==undefined&&t(i,o),i.remove()})}})}}(jQuery);