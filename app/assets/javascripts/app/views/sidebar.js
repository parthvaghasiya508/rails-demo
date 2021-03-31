app.views.Sidebar = app.views.Base.extend({
  el: ".info-bar",

  events: {
    "click input#invite_code": "selectInputText",
    "click .section .title": "toggleSection"
  },

  selectInputText: function(event) {
    event.target.select();
  },

  toggleSection: function(e) {
    $(e.target).closest(".section").toggleClass("collapsed");
  }
});
