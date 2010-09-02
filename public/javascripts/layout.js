$().ready(function() {
  $('#carousel').infiniteCarousel();
  $('input[name|=name_selection]').focus();
  window.scroll(0,0);
  $("a.gallery").fancybox();
});
function print() {
  if (window.print)
    window.print();
  else
    alert("Am sorry your browser does not support print from this icon, please update your browser or go to browser menu andprint.");
}

