// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $('.create_game').loadingWindow();
  $('.share_score').shareScore();
  $('.answer_option').freezeSelection();

  /* Loads the Facebook Connect Javascript API */
  window.fbAsyncInit = function() { 
    FB.init({appId: "166590666700460", status: true, cookie: true, xfbml: true}); 
  }; 

  (function() {   
    var e = document.createElement("script"); 
    e.async = true; 
    e.src = document.location.protocol + "//connect.facebook.net/en_US/all.js"; 
    document.getElementById("fb-root").appendChild(e); 
  }());

});



(function($) {
  $.fn.loadingWindow = function(options) {
    var options = jQuery.extend({}, options);
    return this.each(function() {
      var link = this;
      $(link).click(function () {
        $('#container').html('<div class="waiting_message"> Creating your personalized questions! <br/> <img src="/images/loader.gif" />');
      });
    });
  };

  $.fn.freezeSelection = function(options) {
    var options = jQuery.extend({}, options);
    var selections = this;

    return this.each(function() {
      var selected = this;
      var link = $(selected).find('a:first');
      var selectionHandler = function () {
        $(selected).unbind('click');
        $(selected).click(function(){return false;});
        $(selected).addClass('selected');

        for (var i=0; i < selections.length; i++) {
          if (selected !== selections[i]) {
            $(selections[i]).hide();
          }
        }
      };

      $(selected).click(selectionHandler);
    });
  };

  $.fn.countDown = function(options) {
    var options = jQuery.extend({
      text: '<span id=\'counter\'>%d</span> seconds remaining.',
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

  $.fn.shareScore = function(options) {
    var options = jQuery.extend({}, options)

    var score = jQuery.trim( $('#score').html() );
    var msg = 'scored ' + score + ' points in Riddler';

    return this.each(function() {
        var link = this;

        var streamPublish = function() {
           FB.ui({
              method:  'stream.publish',
              display: 'dialog',
              message: msg,
              attachment: {
                name: 'Riddler Game',
                caption: 'The game which makes you know your friends eerily well!',
                media: [{ 'type': 'image', 'src': 'http://riddle.herko.com/images/riddler_ico.png', 'href': 'http://google.com' }],
                href: 'http://riddle.heroku.com'
              },
              action_links: [{ text: 'Code', href: 'http://github.com/facebook/connect-js' }],
              user_message_prompt: 'Poof moo?'
             },

             function(response) {
             }
           );

        };

        $(link).click(function () {
          streamPublish();
          return false;
        });
    });
  };

})(jQuery);

