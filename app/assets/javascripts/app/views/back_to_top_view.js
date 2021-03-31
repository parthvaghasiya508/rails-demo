app.views.BackToTop = Backbone.View.extend({
  events: {
    "click #back-to-top": "backToTop"
  },

  initialize: function() {
    var throttledScroll = _.throttle(this.toggleVisibility, 250);
    $(window).scroll(throttledScroll);
  },

  backToTop: function(evt) {
    evt.preventDefault();
    $("html, body").animate({scrollTop: 0});
  },

  toggleVisibility: function() {
    if($(document).scrollTop() > 1000) {
      $("#back-to-top").addClass("visible");
    } else {
      $("#back-to-top").removeClass("visible");
    }
  }
});
