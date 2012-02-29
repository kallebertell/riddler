// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $('.create_game').loadingWindow();
  $('.share_score').shareScore();
});



(function($) {
	
  $.loadFacebookConnect = function(options) {
    var options = $.extend({fbAppId : ""}, options);

    window.fbAsyncInit = function() { 
      FB.init({appId: options.fbAppId, status: true, cookie: true, xfbml: true}); 
    }; 

    var e = document.createElement("script"); 
    e.async = true; 
    e.src = document.location.protocol + "//connect.facebook.net/en_US/all.js"; 
    document.getElementById("fb-root").appendChild(e);  
  }

  $.fn.loadingWindow = function(options) {
    var options = $.extend({}, options);
    return this.each(function() {
      var link = this;
      $(link).click(function () {
        $('.boxed_view').html('<div class="waiting_message"> Creating your questions! <br/> <img src="/images/loader.gif" />');
      });
    });
  };

  $.fn.countDown = function(options) {
    var options = $.extend({
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
    var options = $.extend({}, options)

    var caption = $.trim( $('h1.msg').html() );

    return this.each(function() {
        var link = this;

        var streamPublish = function() {
           FB.ui({
              method:  'stream.publish',
              display: 'dialog',
              message: '',
              attachment: {
                name: 'Friddler',
                caption: caption,
                media: [{ 'type': 'image', 'src': 'http://friddler.heroku.com/images/friddler_ico.png', 'href': 'http://friddler.herko.com' }],
                href: 'https://apps.facebook.com/friddler/'
              },
              user_message_prompt: 'Share the love'
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

