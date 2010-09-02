$(document).ready(function() {
		
	//When page loads...
	$(".tab_content").hide(); 	
	$(".tabs  ul li:first").addClass("active").show(); 
	$(".tab_content:first").show(); 

	//On Click Event for Solutions Tabs
	$(".tabs ul li").click(function() {

		$(".tabs ul li").removeClass("active"); 
		$(this).addClass("active"); 
		$(".tab_content").hide(); 

		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});
	

});