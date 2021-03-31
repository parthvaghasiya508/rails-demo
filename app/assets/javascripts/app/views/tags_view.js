app.views.Tags = Backbone.View.extend({
  initialize: function(opts) {
    if(app.publisher) {
      app.publisher.setText("#"+ opts.hashtagName + " ");
    }
    // add avatar fallback if it can't be loaded
    $(app.views.Base.prototype.avatars.selector).error(app.views.Base.prototype.avatars.fallback);
  }
});
