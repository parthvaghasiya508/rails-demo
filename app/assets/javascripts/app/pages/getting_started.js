app.pages.GettingStarted = app.views.Base.extend({
  el: "#hello-there",

  templateName: false,

  subviews: {
    ".aspect_membership_dropdown": "aspectMembershipView"
  },

  initialize: function(opts) {
    this.inviter = opts.inviter;
    app.events.on("aspect:create", this.render, this);
  },

  aspectMembershipView: function() {
    return new app.views.AspectMembership({person: this.inviter, dropdownMayCreateNewAspect: true});
  }
});
