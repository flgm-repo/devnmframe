// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$().ready(function() {
    $(document).ajaxSend(function(event, request, settings) {
        if (typeof(AUTH_TOKEN) == "undefined") return;
        // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
        settings.data = settings.data || "";
        settings.data += (settings.data ? "&amp;" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
    });

    if ($.browser.msie) {
      $("checkbox").click(function() {
        this.blur();
        this.focus();
      });
    }

    $("a.login").fancybox({
        'padding':15,
        'frameWidth':450,
        'frameHeight':400,
        'overlayOpacity':.5
    });
    $("a.login").bind('click', function(){
        $('.application_body').addClass('blockAll');
        $('.login-container').removeClass('hide_fancybox');
        $("a.forgot").fancybox({
            'padding':15,
            'frameWidth':450,
            'frameHeight':450,
            'overlayOpacity':.5
        });
        $("a.signup-now").fancybox({
            'padding':15,
            'frameWidth':450,
            'frameHeight':450,
            'overlayOpacity':.5
        });
    });
    $("a.signup-now").fancybox({
        'padding':15,
        'frameWidth':450,
        'frameHeight':400,
        'overlayOpacity':.5
    });
    $("a.forgot").fancybox({
        'padding':15,
        'frameWidth':450,
        'frameHeight':340,
        'overlayOpacity':.5
    });

    $("a#errors").fancybox({
        'padding':15,
        'frameHeight':100,
        'overlayOpacity':.8,
        'zoomSpeedIn':300,
        'zoomSpeedOut':300,
        'centerOnScroll':false
    });

    $("a#uploaded_images_error").fancybox({
        'padding':15,
        'frameHeight':290,
        'frameWidth':800,
        'overlayOpacity':.8,
        'zoomSpeedIn':300,
        'zoomSpeedOut':300,
        'centerOnScroll':false
    });

    $(".select-app").selectbox();
    $('input .checkbox').checkboxstyle();
    $('input:radio').radiostyle();
    $(".checkout_button").bind("click", function(){
      $.ajax({
        type: "POST",
        url: "/assets/checkout_ajax",
        dataType: "json",
        data: ({
          authenticity_token: encodeURIComponent(AUTH_TOKEN)
        }),
        success: function(msg){
          switch(msg.action){
            case "redirect": window.location = msg.url;break;
            case "show_error": $("#"+msg.selector).trigger('click');break;
          }
        }
      });
    });
});

// Radio Button Validation
// copyright Stephen Chapman, 15th Nov 2004,14th Sep 2005
// you may copy this function but please keep the copyright notice with it

function valButton(btn,form) {
    var cnt = -1;
    for (var i=btn.length-1; i > -1; i--) {
        if (btn[i].checked) {
            cnt = i;
            i = -1;
        }
    }
    if (cnt > -1) {
        form.submit();
        return true;
    }
    else {
        alert('No value selected!');
        return false;
    }
    return false;
}
function validate_radio(form) {
    var btn = valButton(form.group1);
    if (btn == null) {
        return false;
    }
    else return true;
}

function showLoading(show){
  if (show == true){
    $("#loading").show();
  }
  else{
    $("#loading").hide();
  }
}

function update_cost(){
  $.ajax({
    type: "POST",
    url: "/nameframes/get_session_cost",
    dataType: "json",
    data: ({
      authenticity_token: encodeURIComponent(AUTH_TOKEN)
    }),
    success: function(msg){
      $("#value").html(msg);
    }
  });
}

function uploaded_images(){
  images_count = 0;
  $.ajax({
    type: "POST",
    url: "/nameframes/get_session_uploaded_images",
    dataType: "json",
    data: ({
      authenticity_token: encodeURIComponent(AUTH_TOKEN)
    }),
    success: function(msg){
      images_count = msg.uploaded_images
    }
  });
  return images_count;
}

function show_errors(error_message){
  errors_string = "<br/><br/>" + error_message + "<br/><br/>";
  $('#errors-box').html(errors_string);
  $('#errors').trigger('click');
}

function hide(){
    $(".error-message").hide();
}

function closeAllFancyWindows(){
  $.fn.fancybox.close();
}

