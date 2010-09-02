var isFinalizeClicked = false;

$().ready(function(){
  form_validation_descriptor = function() {
    $("#submit_order_form").validate({
      rules: {
        username: {
          required: true,
          minlength: 2
        },
        password_field: {
          required: false,
          minlength: 5
        },
        confirm_password_field: {
          required: "#password_field:filled",
          minlength: 5,
          equalTo: "#password_field"
        },
        email_address: {
          required: true,
          email: true
        },
        billing_first_name:"required",
        billing_last_name:"required",
        billing_address_1:{
          required: true
        },
        billing_state_hidden:{
          required:true
        },
        billing_city:{
          required: true
        },
        billing_zip:{
          required: true,
          minlength: 5,
          maxlength: 5,
          digits: true
        },
        billing_country_hidden:{
          required:true
        },
        shipping_first_name:{
          required: true
        },
        shipping_last_name:{
          required: true
        },
        shipping_address_1:{
          required: true
        },
        shipping_state_hidden:{
          required:true
        },
        shipping_city:{
          required: true
        },
        shipping_zip:{
          required: true,
          minlength: 5,
          maxlength: 5,
          digits: true
        },
        shipping_country_hidden:{
          required:true
        },
        credit_card_number:{
          required:true
        },
        card_type:{
          required:true
        },
        cvv:{
          required:true
        },
        expiration_month:{
          required:true
        },
        expiration_year:{
          required:true
        },
        gift_to: {
          required: "#is_gift:checked"
        },
        gift_from: {
          required: "#is_gift:checked"
        }
      },
      messages: {
        username: {
          required: "Please enter a username",
          minlength: "Your username must consist of at least 2 characters"
        },
        password: {
          required: "Please provide a password",
          minlength: "Your password must be at least 5 characters long"
        },
        confirm_password: {
          required: "Passwords do not match",
          minlength: "Passwords do not match",
          equalTo: "Passwords do not match"
        },
        email: "Please enter a valid email address"
      }
    })
  };

  form_validation_descriptor();

  $("#shipping_state_dropdown option[value='AL']").attr('selected', 'selected');
  $("#shipping_country_select option[value='USA']").attr('selected', 'selected');

  $('#shipping_state_hidden').val('AL');
  $('#shipping_country_hidden').val('USA');

  $("a#cvv-explanation").fancybox({
      'padding':15,
      'overlayOpacity':.8,
      'frameWidth':590,
      'frameHeight':264,
      'zoomSpeedIn':300,
      'zoomSpeedOut':300,
      'centerOnScroll':false
  });
  $("a#confirm").fancybox({
      'padding':15,
      'frameWidth':700,
      'frameHeight':540,
      'overlayOpacity':.8,
      'zoomSpeedIn':300,
      'showCloseButton': false,
      'zoomSpeedOut':300,
      'centerOnScroll':false
  });

  $("#is_gift").bind("change click", function(){
    checked = $('#is_gift').attr("checked")
    if (checked){
      $("#gift_to").removeClass("disabled");
      $("#gift_from").removeClass("disabled");
      $("#gift_message").removeClass("disabled");
    }
    else{
      $("#gift_to").addClass("disabled");
      $("#gift_from").addClass("disabled");
      $("#gift_message").addClass("disabled");
    }
  });

  $("a#confirm").click(function (){
      $('#application_body').addClass('blockAll');
  });
  $("a#errors").click(function (){
      $('#application_body').addClass('blockAll');
  });


  $("#finalize_button").click(function (){
    if (isFinalizeClicked == undefined){
      var isFinalizeClicked = false
    }
    if(isFinalizeClicked) {
        return;
    } else {

        isFinalizeClicked = true;
        //Show some kind of progress bar

        // validate the comment form when it is submitted
        //form_validation_descriptor();
        var terms_valid = false;
        var shipping_type_selected = false;
        if ($('#terms:checked').val() == null){
          $('#terms').parent().addClass("error");
          terms_valid = false;
        }
        else{
          $('#terms_div').html('');
          $('#terms').parent().removeClass("error");
          terms_valid = true;
        }
        if ($(".shipping_cost").parent(".checked").children().val() == undefined){
          $('.normal_shipping').parent().addClass("error");
          shipping_type_selected = false;
        }
        else{
          $('.normal_shipping').parent().removeClass("error");
          shipping_type_selected = true;
        }

        // validate signup form on keyup and submit
        if($('#submit_order_form').valid() && terms_valid && shipping_type_selected){
          $.ajax({
            type: "POST",
            url: "/checkout/validate_cc_number",
            data: ({
              b_first_name: $('#billing_first_name').val(),
              b_last_name: $('#billing_last_name').val(),
              cc : $('#credit_card_number').val(),
              cvv: $('#cvv').val(),
              exp_month: $('#expiration_month').val(),
              exp_year:  $('#expiration_year').val(),
              cc_type: $('#card_type:checked').val()
            }),
            dataType: "json",
            success: function(msg) {
              if(msg.status != "success"){
                var errors = msg.creditcard_errors;
                var errors_string = "There were some errors in your Credit Card data:<br/><br/>";
                errors_string += "<ul style='list-style-type:none'>";
                if (errors.number != undefined){
                  errors_string += "<li><b>Credit Card:</b>" + errors.number + "</li>";
                }
                if (errors.year != undefined){
                  errors_string += "<li><b>Year:</b>" + errors.year + "</li>";
                }
                if (errors.month != undefined){
                  errors_string += "<li><b>Month:</b>" + errors.month + "</li>";
                }
                if (errors.type != undefined){
                  errors_string += "<li><b>Credit Card Type:</b>" + errors.type + "</li>";
                }
                errors_string += "</ul>";
                show_errors(errors_string);

              } else {

                $.ajax({
                  type: "POST",
                  url: "/checkout/calculate_costs",
                  data:({
                    how_did_you_hear_about_us: $('#how_did_you_hear_about_us').val(),
                    shipping_city: $('#shipping_city').val(),
                    shipping_state: $('#shipping_state_hidden').val(),
                    shipping_country: $('#shipping_country_hidden').val(),
                    shipping_type: $(".shipping_cost").parent(".checked").children().val()
                  }),
                  dataType: "json",
                  success: function(msg){
                    if(msg.fail){
                      alert(msg.message);
                    } else {
                      finalize(msg.nameframe_cost, msg.shipping_cost, msg.tax, msg.total);
                      $('#confirm').trigger('click');
                    }
                  },
                  complete: function() {
                    isFinalizeClicked = false;
                  }
                });
              }
            },
            complete: function() {
              isFinalizeClicked = false;
            }
          });

        } else {

            isFinalizeClicked = false;
            return false;

        }

    }
  });

});

function finalize(nameframe_cost, shipping_cost, tax, total){
  $('#email_label').html($('#email_address').val());
  $('#nameframe_cost_label').html(formatCurrency(nameframe_cost));
  $('#shipping_cost_label').html(formatCurrency(shipping_cost));

  $('#tax_label').html(formatCurrency(tax));

  $('#order_total_label').html(formatCurrency(total));

  var location1 = $('#billing_city').val();
  if($('#billing_country_hidden').val() == 'USA'){
    location1 = location1 + ', '+$('#billing_state_hidden').val();
  }
  else{
    location1 = location1 + ', '+$('#billing_state_text').val();
  }
  location1 = location1 + ", "+$('#billing_country_hidden').val();
  location1 = location1 + ", ZIP: "+$('#billing_zip').val();
  $('#billing_location_label').html(location1);
  $('#billing_address_1_label').html($('#billing_address_1').val());
  $('#billing_address_2_label').html($('#billing_address_2').val());
  $('#billing_name_label').html($('#billing_first_name').val()+' '+$('#billing_last_name').val());
  var location2 = $('#shipping_city').val();
  if($('#shipping_country_hidden').val() == 'USA'){
    location2 = location2 + ', '+$('#shipping_state_hidden').val();
  }
  else{
    location2 = location2 + ', '+$('#shipping_state_text').val();
  }
  location2 = location2 + ", "+$('#shipping_country_hidden').val();
  location2 = location2 + ", ZIP: "+$('#shipping_zip').val();
  $('#shipping_location_label').html(location2);
  $('#shipping_address_1_label').html($('#shipping_address_1').val());
  $('#shipping_address_2_label').html($('#shipping_address_2').val());
  $('#shipping_name_label').html($('#shipping_first_name').val()+' '+$('#shipping_last_name').val());
  $('#expiray_date_label').html($('#expiration_month').val()+'/'+$('#expiration_year').val());
  $('#credit_card_label').html($('#credit_card_number').val().replace($('#credit_card_number').val().substring(0, 12), "XXXXXXXXXXXX") );
  $('#card_type_label').html($('#card_type:checked').val());
  $('#ccv_label').html($('#cvv').val());
  return false
}

function submit_checkout_form(){
  $.ajax({
    type: "POST",
    url: "/checkout/submit_order",
    data:$("#submit_order_form :input").serialize(),
    beforeSend: function(){$.fn.fancybox.showLoading(); $('.buttons').hide();},
    dataType: "json",
    success: function(msg){
      if(msg.status == "failure"){
        show_errors(msg.message);
        if (msg.error_type == "email_blank"){
          $("#email_address").addClass('error');
          $('.buttons').show();
        }
        if (msg.error_type == "user_account"){
          $("#email_address").addClass('error');
          $("#password_field").addClass('error');
          $("#confirm_password_field").addClass('error');
          $('.buttons').show();
        }
        if (msg.error_type == "billing_address"){
          $("#billing_first_name").addClass('error');
          $("#billing_last_name").addClass('error');
          $("#billing_address_1").addClass('error');
          $("#billing_city").addClass('error');
          $("#billing_zip").addClass('error');
          $('.buttons').show();
        }
        if (msg.error_type == "shipping_address"){
          $("#shipping_first_name").addClass('error');
          $("#shipping_last_name").addClass('error');
          $("#shippin_address_1").addClass('error');
          $("#shipping_city").addClass('error');
          $("#shipping_zip").addClass('error');
          $('.buttons').show();
        }
        if (msg.error_type == "credit_card"){
          $("#credit_card_number").addClass('error');
          $("#cvv").addClass("error");
          $('.buttons').show();
          }
      }
      else if(msg.status == "success"){
        window.location = msg.redirect_to
      }
      $.fn.fancybox.close();
      $('#application_body').removeClass('blockAll');
    }
  });
}

function formatCurrency(num) {
  num = num.toString().replace(/\$|\,/g,'');
  if(isNaN(num))
    num = "0";
  sign = (num == (num = Math.abs(num)));
  num = Math.floor(num*100+0.50000000001);
  cents = num%100;
  num = Math.floor(num/100).toString();
  if(cents<10)
    cents = "0" + cents;
  for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
    num = num.substring(0,num.length-(4*i+3))+','+num.substring(num.length-(4*i+3));
  return (((sign)?'':'-') + '$' + num + '.' + cents);
}

