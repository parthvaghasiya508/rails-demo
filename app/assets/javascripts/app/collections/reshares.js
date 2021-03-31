app.collections.Reshares = Backbone.Collection.extend({
  model: app.models.Reshare,

  initialize: function(models, options) {
    this.url = "/posts/" + options.post.id + "/reshares";
  }
});
