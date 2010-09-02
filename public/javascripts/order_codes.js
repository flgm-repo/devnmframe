$().ready(function(){
  $("#free_nameframe_code_indefinite_users").bind("click", function(){
    if (this.checked){
      $("#free_nameframe_code_users_quantity").attr("disabled", "disabled");
      $("#free_nameframe_code_users_quantity").attr("value", "Indefinite");
    }
    else{
      $("#free_nameframe_code_users_quantity").removeAttr("disabled");
      $("#free_nameframe_code_users_quantity").attr("value", "");
      $("#free_nameframe_code_users_quantity").focus();
    }
  })
})

