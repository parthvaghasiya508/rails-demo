app.views.Aspect = app.views.Base.extend({
  templateName: "aspect",

  tagName: "li",

  className: 'hoverable',

  events: {
    "click .aspect-item": "toggleAspect"
  },

  toggleAspect: function(evt) {
    if (evt) { evt.preventDefault(); }
    this.model.toggleSelected();

    app.router.aspects_stream();
  },

  presenter : function() {
    return _.extend(this.defaultPresenter(), {
      aspect : this.model
    });
  }
});
