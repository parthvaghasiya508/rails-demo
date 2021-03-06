app.models.User = Backbone.Model.extend({
  toggleNsfwState : function() {
    if(!app.currentUser.authenticated()){ return false }
    this.set({showNsfw : !this.get("showNsfw")});
    this.trigger("nsfwChanged");
  },

  authenticated : function() {
    return !!this.id;
  },

  expProfileUrl : function(){
    return "/people/" + app.currentUser.get("guid") + "?ex=true";
  },

  isServiceConfigured : function(providerName) {
    return _.include(this.get("configured_services"), providerName);
  },

  isAuthorOf: function(model) {
    return this.authenticated() && model.get("author").id === this.id;
  }
});
