jQuery(document).ready(function($) {
  
  if ($(".notice").length) {
    $(".notice").delay("2000").slideUp("slow")
  }
  
  if ($('#cloud_preview_loading').length) {
    setTimeout(updatePreview, 3000);
  }
  $('.zoom').zoomy();
});

function updatePreview () {
  var cloud_id = $("#cloud_preview_loading").attr("data-id");
  $.getScript("/clouds/" + cloud_id + ".js");
}