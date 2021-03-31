app.views.ResharesInfo = app.views.Base.extend({

  templateName : "reshares-info",

  events : {
    "click .expand-reshares" : "showAvatars"
  },

  tooltipSelector : ".avatar",

  initialize : function() {
    this.model.interactions.reshares.bind("change", this.render, this);
    this.displayAvatars = false;
  },

  presenter : function() {
    return _.extend(this.defaultPresenter(), {
      reshares : this.model.interactions.reshares.toJSON(),
      resharesCount : this.model.interactions.resharesCount(),
      displayAvatars: this.displayAvatars
    });
  },

  showAvatars : function(evt){
    if(evt) { evt.preventDefault() }
    this.displayAvatars = true;
    this.model.interactions.reshares.fetch({success: function() {
      this.model.interactions.reshares.trigger("change");
    }.bind(this)});
  }
});
