app.views.Header = app.views.Base.extend({

  templateName: "header",

  className: "dark-header",

  presenter: function() {
    return _.extend({}, this.defaultPresenter(), {
      podname: gon.appConfig.settings.podname
    });
  },

  postRenderTemplate: function() {
    new app.views.Notifications({el: "#notification-dropdown", collection: app.notificationsCollection});
    new app.views.NotificationDropdown({el: "#notification-dropdown", collection: app.notificationsCollection});
    new app.views.Search({el: "#header-search-form"});
  },

  menuElement: function() { return this.$("ul.dropdown"); }
});
