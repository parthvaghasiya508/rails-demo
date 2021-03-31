app.views.SinglePostInteractions = app.views.Base.extend({
  templateName: "single-post-viewer/single-post-interactions",
  className: "framed-content",

  subviews: {
    "#comments": "commentStreamView",
    "#interaction-counts": "interactionCountsView"
  },

  commentStreamView: function() {
    return new app.views.SinglePostCommentStream({model: this.model});
  },

  interactionCountsView: function() {
    return new app.views.SinglePostInteractionCounts({model: this.model});
  }
});
