app.collections.Pods = Backbone.Collection.extend({
  model: app.models.Pod,

  comparator: function(model) {
    var host = model.get("host") || "";
    return host.toLowerCase();
  }
});
