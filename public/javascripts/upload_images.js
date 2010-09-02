$().ready(function() {
  $("a#flex").fancybox({
      'padding':15,
      'frameWidth':910,
      'frameHeight':710,
      'overlayOpacity':.5
  });
  $("a#confirmation").fancybox({
      'padding':15,
      'frameHeight':100,
      'overlayOpacity':.8,
      'zoomSpeedIn':300,
      'zoomSpeedOut':300,
      'centerOnScroll':false
  });
  ( $("#uploaded_images").children().length > 0 )? showButtonAddImagesToFrame : hideButtonAddImagesToFrame();

  $("#uploaded_images a.delete-image").live("click", function(){
    $.ajax({
      type: "POST",
      url: "/assets/destroy_image",
      dataType: "script",
      async: false,
      data: ({
        authenticity_token: encodeURIComponent(AUTH_TOKEN),
        image_id: $(this).attr("image_id")
      }),
      beforeSend: function(){
        showLoading(true);
      },
      success: function(msg){
      },
      complete: function(){
        showLoading(false);
      }
    });
  });
})

function update_page_data(){
  $("#divFileProgressContainer").html("");
  hideButtonAddImagesToFrame();
}

function hideButtonAddImagesToFrame(){
  $("a#flex").hide();
}
function showButtonAddImagesToFrame(){
  $("a#flex").show();
}

function closeFlexPopupWindow(){
  $.fn.fancybox.close();
  img_src = $(".preview img").attr("src").split("?")[0];
  $(".preview img").attr("src", img_src + "?" + Math.round(Math.random() * 100000));
}

function enabled_to_upload(){
  var enabled = false;
  $.ajax({
    type: "POST",
    url: "/nameframes/get_session_enabled_to_upload",
    dataType: "json",
    async: false,
    data: ({
      authenticity_token: encodeURIComponent(AUTH_TOKEN)
    }),
    success: function(msg){
      enabled = msg.enabled;
    }
  });
  return enabled;
}
