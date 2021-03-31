app.views.Photo = app.views.Base.extend({

  templateName: "photo",

  className : "photo loaded col-md-4 col-sm-6 clearfix",

  events: {
    "click .remove_post": "destroyModel"
  },

  tooltipSelector : ".control-icons a",

  initialize : function() {
    $(this.el).attr("id", this.model.get("guid"));
    return this;
  },

  presenter : function() {
    return _.extend(this.defaultPresenter(), {
      authorIsCurrentUser : app.currentUser.isAuthorOf(this.model)
    });
  }
});
