jQuery(document).ready(function($) {
  
  if ($(".notice").length) {
    $(".notice").delay("2000").slideUp("slow")
  }
  
  if ($('#cloud_preview_loading').length) {
    setTimeout(updatePreview, 3000);
    start_loading_screen();
  }
  $('.zoom').zoomy();
});

function updatePreview () {
  var cloud_id = $("#cloud_preview_loading").attr("data-id");
  $.getScript("/clouds/" + cloud_id + ".js");
}

function start_loading_screen() {
  if ($('#cloud_preview_loading').length) {
    var paper = Raphael("cloud_preview_loading",320, 200);

    // Creates circle at x = 50, y = 40, with radius 10
    var circle = paper.circle(50, 40, 10);
    // Sets the fill attribute of the circle to red (#f00)
    circle.attr("fill", "#f00");

    // Sets the stroke attribute of the circle to white
    circle.attr("stroke", "#fff");
  }
}