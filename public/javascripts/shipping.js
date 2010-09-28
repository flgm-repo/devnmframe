$().ready(function(){
  shipping_is_same_as_billing = false

  $("#billing_state_dropdown").change(function(){
    $('#billing_state_hidden').val($('#billing_state_dropdown').val());

    if (shipping_is_same_as_billing){
      checkShippingStateSelected($('#billing_state_hidden').val());
      call_toggle(true);
    }
    update_total_cost();
  });

  $("#shipping_state_dropdown").change(function(){
    selected_shipping_state = $('#shipping_state_dropdown').val()
    $('#shipping_state_hidden').val(selected_shipping_state);
    checkShippingStateSelected(selected_shipping_state);
    update_total_cost();
  });

  $("#how_did_you_hear_about_us").change(function(){
    update_total_cost();
  });

  $(".shipping_cost").change(function(){
    update_total_cost();
  });

  $("#billing_country_select").change(function(){
    selected_billing_country = $('#billing_country_select').val();
    $('#billing_country_hidden').val(selected_billing_country);
    if (selected_billing_country == 'USA'){
      $('#billing_state_text_field').hide();
      $('#billing_state_dropdown_field').show();
      $('#billing_state_hidden').val('AL');
    }
    else{
      $('#billing_state_dropdown_field').hide();
      $('#billing_state_text_field').show();
      $('#billing_state_hidden').val($('#billing_state_text').val());
    }
    if (shipping_is_same_as_billing){
      checkShippingCountrySelected(selected_billing_country);
      call_toggle(true);
    }
    update_total_cost();
  });

  $("#shipping_country_select").change(function(){
    selected_shipping_country = $('#shipping_country_select').val()
    $('#shipping_country_hidden').val(selected_shipping_country);
    if(selected_shipping_country == 'USA') {
      $('#state_text_field').hide();
      $('#state_dropdown_field').show();
      $('#shipping_state_hidden').val('AL');
    }
    else{
      $('#state_dropdown_field').hide();
      $('#state_text_field').show();
      $('#shipping_state_hidden').val($('#shipping_state_text').val());
    }
    checkShippingCountrySelected(selected_shipping_country);
    update_total_cost();
  });

  $("#shipping_is_same").bind(($.browser.msie)? "click" : "change", function(){
    checked = $('#shipping_is_same').attr("checked");
    if (checked == true){
      $('#ship_div').slideUp('slow');
      shipping_is_same_as_billing = true;
      is_special_country = checkShippingCountrySelected($('#billing_country_hidden').val());
      if (!is_special_country){
        checkShippingStateSelected($('#billing_state_hidden').val());
      }
      call_toggle(true);
    }
    else{
      $('#ship_div').slideDown('slow');
      shipping_is_same_as_billing = false;
      call_toggle(false);
      is_special_country = checkShippingCountrySelected($('#shipping_country_hidden').val());
      if (!is_special_country){
        checkShippingStateSelected($('#shipping_state_hidden').val());
      }
    }
    update_total_cost();
  });
});

function checkShippingStateSelected(state){
  uncheck_shipping_costs();
  if (state == "HI" || state == "AK"){
    $('p.special_shipping').show();
    $('p.normal_shipping').hide();
    return true
  }
  else{
    $('p.normal_shipping').show();
    $('p.special_shipping').hide();
    return false
  }
}

function checkShippingCountrySelected(country){
  if(country == 'USA') {
    $('p.normal_shipping').show();
    $('p.special_shipping').hide();
    return false
  }
  else{
    $('p.special_shipping').show();
    $('p.normal_shipping').hide();
    return true
  }
}

function uncheck_shipping_costs(){
  $('.shipping_cost').attr("checked", false);
  $('.shipping_cost').parent().removeClass("checked");
}

function call_toggle(checked){
  if(checked == true){
    $('#shipping_first_name').val($('#billing_first_name').val());
    $('#shipping_last_name').val($('#billing_last_name').val());
    $('#shipping_address_1').val($('#billing_address_1').val());
    $('#shipping_address_2').val($('#billing_address_2').val());
    $('#shipping_city').val($('#billing_city').val());
    $('#shipping_zip').val($('#billing_zip').val());

    $('#shipping_country_hidden').val($('#billing_country_hidden').val());
    $('#shipping_state_hidden').val($('#billing_state_hidden').val());

    $('#shipping_country_select').attr('disabled', 'disabled');
    $('#shipping_state_text').attr('disabled', 'disabled');
    $('#shipping_state_dropdown').attr('disabled', 'disabled');
  }
  else{
    $('#shipping_country_hidden').val($('#shipping_country_select :selected').val());
    $('#shipping_state_hidden').val($('#shipping_state_dropdown :selected').val());

    $('#shipping_country_select').removeAttr('disabled');
    $('#shipping_state_text').removeAttr('disabled');
    $('#shipping_state_dropdown').removeAttr('disabled');
  }
}

function update_total_cost(){
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
	  $('#creditCardBlock1 :input').attr('disabled', true);
	  $('#creditCardBlock1').addClass("idleField");
	  /*$('#creditCardBlock2 :input').attr('disabled', true);
	  $('#creditCardBlock2').addClass("idleField");*/
	  $(".order-total p span").html(formatCurrency(msg.total));
    }
  });
}

