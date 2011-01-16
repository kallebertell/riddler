// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $('.create_game').loadingWindow();
});



(function($) {
  $.fn.loadingWindow = function(options) {
    var options = jQuery.extend({}, options);
    return this.each(function() {
      var link = this;
      $(link).click(function () {
        $('#container').html('Prepare for the game to begin!');
      });
    });
  };
})(jQuery);

