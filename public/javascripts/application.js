// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $('.create_game').loadingWindow();
  $('.answer_option').freezeSelection();
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

  $.fn.freezeSelection = function(options) {
    var options = jQuery.extend({}, options);
    var selections = this;

    return this.each(function() {
      var selected = this;

      $(selected).click(function () {
        for (var i=0; i < selections.length; i++) {
          if (selected === selections[i]) {
            $(selections[i]).addClass('selected');
            $(selections[i]).click(function() {
              return false;
            });
          } else {
            $(selections[i]).hide();
          }
        }
      });
    });
  };

  $.fn.countDown = function(options) {
    var options = jQuery.extend({
      text: 'You have %d seconds remaining.',
      limit: 10,
      url: '',
      target: 'body'
    }, options);

    return this.each(function() {
      var that = this;
      var remaining = options.limit;
      var prefix = options.text.split('%d')[0];
      var suffix = options.text.split('%d')[1];
      var displayRemainingTime = function(remaining) {
        $(that).html(prefix + remaining + suffix);
        if (remaining <= 4) {
          $(that).css('color', 'red');
        } else if (remaining <= 5) {
          $(that).css('color', 'orange');
        }
      };
      displayRemainingTime(remaining);
      var jobId = window.setInterval(function() {
        if (--remaining > 0) {
          displayRemainingTime(remaining);
        } else {
          $.post(options.url, function(data) {
            $(options.target).html(data);
          });
          window.clearInterval(jobId);
        }
      }, 1000);
    });
  };

})(jQuery);

