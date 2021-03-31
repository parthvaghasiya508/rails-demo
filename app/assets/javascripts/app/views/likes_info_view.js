app.views.LikesInfo = app.views.Base.extend({

  templateName : "likes-info",

  events : {
    "click .expand-likes" : "showAvatars"
  },

  tooltipSelector : ".avatar",

  initialize : function() {
    this.model.interactions.likes.on("change", this.render, this);
    this.displayAvatars = false;
  },

  presenter : function() {
    return _.extend(this.defaultPresenter(), {
      likes : this.model.interactions.likes.toJSON(),
      likesCount : this.model.interactions.likesCount(),
      displayAvatars: this.displayAvatars
    });
  },

  showAvatars : function(evt){
    if(evt) { evt.preventDefault() }
    this.displayAvatars = true;
    this.model.interactions.likes.fetch({success: function() {
      this.model.interactions.likes.trigger("change");
    }.bind(this)});
  }
});
