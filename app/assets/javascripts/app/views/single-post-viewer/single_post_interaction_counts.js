app.views.SinglePostInteractionCounts = app.views.Base.extend({
  templateName: "single-post-viewer/single-post-interaction-counts",
  tooltipSelector: ".avatar.micro",

  initialize: function() {
    this.model.interactions.on("change", this.render, this);
  },

  presenter: function() {
    var interactions = this.model.interactions;
    return {
      likes: interactions.likes.toJSON(),
      reshares: interactions.reshares.toJSON(),
      commentsCount: interactions.commentsCount(),
      likesCount: interactions.likesCount(),
      resharesCount: interactions.resharesCount()
    };
  }
});
