app.views.Base = Backbone.View.extend({

  initialize : function() {
    this.setupRenderEvents();
  },

  presenter : function(){
    return this.defaultPresenter();
  },

  setupRenderEvents : function(){
    // this line is too generic.  we usually only want to re-render on
    // feedback changes as the post content, author, and time do not change.
    //
    // this.model.bind('change', this.render, this);
  },

  defaultPresenter : function(){
    var modelJson = this.model && this.model.attributes ? _.clone(this.model.attributes) : {};

    return _.extend(modelJson, {
      current_user : app.currentUser.attributes,
      loggedIn : app.currentUser.authenticated()
    });
  },

  render : function() {
    this.renderTemplate();
    this.renderSubviews();
    this.renderPluginWidgets();
    this.removeTooltips();

    return this;
  },

  renderTemplate : function(){
    var presenter = _.isFunction(this.presenter) ? this.presenter() : this.presenter;
    this.template = HandlebarsTemplates[this.templateName+"_tpl"];

    if (this.templateName === false) {
      return;
    }

    if (!this.templateName) {
      throw new Error("No templateName set, set to false to ignore.");
    }

    if (!this.template) {
      throw new Error("Invalid templateName provided: " + this.templateName);
    }

    this.$el
      .html(this.template(presenter))
      .attr("data-template", _.last(this.templateName.split("/")));

    // add avatar fallback if it can't be loaded
    this.$el.find(this.avatars.selector).error(this.avatars.fallback);

    // add placeholder support for old browsers
    this.$("input, textarea").placeholder();

    // init autosize plugin
    autosize(this.$("textarea"));

    this.postRenderTemplate();
  },

  postRenderTemplate: $.noop, //hella callbax yo

  renderSubviews : function(){
    var self = this;
    _.each(this.subviews, function(property, selector){
      var view = _.isFunction(self[property]) ? self[property]() : self[property];
      if (view && self.$(selector).length > 0) {
        self.$(selector).empty();
        self.$(selector).html(view.render().el);
        view.delegateEvents();
      }
    });
  },

  renderPluginWidgets : function() {
    this.$(this.tooltipSelector).tooltip();
    this.$("time").timeago();
  },

  removeTooltips : function() {
    $(".tooltip").remove();
  },

  setFormAttrs : function(){
    function setValueFromField(memo, attribute, selector){
      if(attribute.slice("-2") === "[]") {
        memo[attribute.slice(0, attribute.length - 2)] = _.pluck(this.$el.find(selector).serializeArray(), "value");
      } else {
        memo[attribute] = this.$el.find(selector).val() || this.$el.find(selector).text();
      }
      return memo;
    }

    this.model.set(_.inject(this.formAttrs, _.bind(setValueFromField, this), {}));
  },

  report: function(evt) {
    if(evt) { evt.preventDefault(); }
    var msg = prompt(Diaspora.I18n.t('report.prompt'), Diaspora.I18n.t('report.prompt_default'));
    if (msg == null) {
      return;
    }
    var data = {
      report: {
        item_id: this.model.id,
        item_type: $(evt.currentTarget).data("type"),
        text: msg
      }
    };

    var report = new app.models.Report();
    report.save(data, {
      success: function() {
        app.flashMessages.success(Diaspora.I18n.t("report.status.created"));
      },
      error: function() {
        app.flashMessages.error(Diaspora.I18n.t("report.status.exists"));
      }
    });
  },

  destroyConfirmMsg: function() { return Diaspora.I18n.t("confirm_dialog"); },

  destroyModel: function(evt) {
    evt && evt.preventDefault();
    var self = this;
    var url = this.model.urlRoot + "/" + this.model.id;

    if( confirm(_.result(this, "destroyConfirmMsg")) ) {
      this.$el.addClass("deleting");
      this.model.destroy({ url: url })
        .done(function() {
          self.remove();
        })
        .fail(function() {
          self.$el.removeClass("deleting");
          app.flashMessages.error(Diaspora.I18n.t("failed_to_remove"));
        });
    }
  },

  avatars: {
    fallback: function() {
      $(this).attr("src", ImagePaths.get("user/default.png"));
    },
    selector: "img.avatar"
  }
});

app.views.StaticContentView = app.views.Base.extend({
  initialize : function(options) {
    this.templateName = options.templateName;
    this.data = options.data;

    return this;
  },

  presenter : function(){
    return this.data;
  },
});
