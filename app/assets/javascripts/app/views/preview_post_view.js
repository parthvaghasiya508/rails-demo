app.views.PreviewPost = app.views.Post.extend({
  templateName: "stream-element",
  className: "stream-element loaded",

  subviews: {
    ".feedback": "feedbackView",
    ".post-content": "postContentView",
    ".oembed": "oEmbedView",
    ".opengraph": "openGraphView",
    ".poll": "pollView",
    ".status-message-location": "postLocationStreamView"
  },

  tooltipSelector: [
    ".timeago",
    ".delete",
    ".permalink"
  ].join(", "),

  initialize: function() {
    this.model.set("preview", true);
    this.oEmbedView = new app.views.OEmbed({model: this.model});
    this.openGraphView = new app.views.OpenGraph({model: this.model});
    this.pollView = new app.views.Poll({model: this.model});
  },

  feedbackView: function() {
    return new app.views.Feedback({model: this.model});
  },

  postContentView: function() {
    return new app.views.StatusMessage({model: this.model});
  },

  postLocationStreamView: function() {
    return new app.views.LocationStream({model: this.model});
  }
});
