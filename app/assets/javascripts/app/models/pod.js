app.models.Pod = Backbone.Model.extend({
  urlRoot: Routes.adminPods(),

  recheck: function() {
    var self = this,
        url  = Routes.adminPodRecheck(this.id).toString();

    return $.ajax({url: url, method: "POST", dataType: "json"})
      .done(function(newAttributes) {
        self.set(newAttributes);
      });
  }
});
