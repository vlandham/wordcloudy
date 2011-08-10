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
    var width = 450,
        height = 564;
    var paper = Raphael("cloud_preview_loading",width,height);
    var cloud1_path = "M376.097,165.737c4.204-3.929,6.836-9.521,6.836-15.73 c0-11.893-9.64-21.532-21.531-21.532c-1.789,0-3.526,0.222-5.188,0.634c-2.507-9.301-10.999-16.149-21.094-16.149 c-1.373,0-2.715,0.133-4.018,0.375c-4.981-7.117-13.234-11.774-22.581-11.774c-2.952,0-5.792,0.469-8.459,1.329 c2.757-4.544,4.344-9.875,4.344-15.578c0-16.614-13.468-30.082-30.082-30.082c-9.4,0-17.79,4.314-23.306,11.067 c-3.956-2.367-8.581-3.73-13.526-3.73c-8.723,0-16.454,4.236-21.258,10.76c-2.979-12.554-14.255-21.896-27.72-21.896 c-14.038,0-25.696,10.152-28.055,23.513c-3.167-0.873-6.499-1.348-9.943-1.348c-14.168,0-26.494,7.887-32.829,19.509 c-2.725-2.292-6.238-3.677-10.077-3.677c-8.656,0-15.674,7.018-15.674,15.674c0,0.053,0.007,0.105,0.008,0.158 c-0.002,0-0.005,0-0.008,0c-11.717,0-21.215,9.498-21.215,21.215c0,4.959,1.706,9.517,4.558,13.129 c-7.916,3.599-13.424,11.569-13.424,20.832c0,11.214,8.072,20.538,18.721,22.494c3.794,10.473,13.827,17.957,25.609,17.957 c4.17,0,7.836-1.756,11.65-2.613l0,0c56.456,0.009,225.823,0.079,225.823,0.079c1.701,10.345,6.946,15.886,19.011,15.833 C375.959,216.127,388,199.791,388,186.5C388,177.648,383.216,169.917,376.097,165.737z";
    
    
    var cloud = paper.path(cloud1_path);
    cloud.attr("fill", "#ffffff");
    cloud.attr("stroke", "#69D2E7");
    cloud.attr("stroke-width", 5);
    var attrs = [{scale: 0.8, fill:"#ffffff"}, {scale: 1.0, fill:"#69D2E7"}],
                  now = 0;
    
    text = paper.text(width / 2, height / 2, "Creating Word Cloud.\nPlease Wait.");
    text.attr("font-size", 34);
    
    var characters = ["B", "C", "D", "E", "F", "G", "H", "I", "J", "K", 
                      "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
                      "W", "X", "Y", "Z"]
    
    var letter = paper.path("M0,0L0,0z").attr({fill: "#444", stroke: "#fff", "fill-opacity": .3, "stroke-width": 0, "stroke-linecap": "round", translation: "50 50"});
    
    
    function run() {
      cloud.animate(attrs[now++], 2000, ">", run);
      index = randomFromTo(0,(characters.length - 1))
      if (characters[index] && characters[index] in helvetica) {
        letter.attr({path: helvetica[characters[index]], translation:top_translation(width, height), "fill-opacity": 0.3});
        letter.animate({translation:new_translation(width, height), "fill-opacity": 0}, 2000);
      }
      
      if (now == 2) {
        now = 0;
      }
    };
    run();
  }
}

function top_translation(width, height) {
  x_cord = width / 2 - 50;
  y_cord = 80;
  str = x_cord + " " + y_cord;
  return str;
}

function new_translation(width, height) {
  x_cord = width / 2 - 70;
  y_cord = height / 2 - 30;
  str =  "0 " + y_cord;
  return str;
}

function randomFromTo(from, to){
       return Math.floor(Math.random() * (to - from + 1) + from);
    }