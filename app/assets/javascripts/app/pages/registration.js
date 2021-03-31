app.pages.Registration = Backbone.View.extend({
  initialize: function() {
    $("input#user_email").popover({
      placement: "left",
      trigger: "focus"
    }).popover("show");
  }
});
