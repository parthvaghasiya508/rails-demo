app.models.AspectSelection = Backbone.Model.extend({
  toggleSelected: function(){
    this.set({"selected" : !this.get("selected")}, {async: false});
  }
});
