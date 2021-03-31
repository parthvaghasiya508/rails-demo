app.collections.Aspects = Backbone.Collection.extend({
  model: app.models.Aspect,
  url: "/aspects"
});
