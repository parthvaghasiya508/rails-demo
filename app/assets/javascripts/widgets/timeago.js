(function() {
  Diaspora.Widgets.TimeAgo = function() {
    this.subscribe("widget/ready", function() {
      if (Diaspora.I18n.language !== "en") {
        $.timeago.settings.lang = Diaspora.I18n.language;
        $.timeago.settings.strings[Diaspora.I18n.language] = {};
        $.each($.timeago.settings.strings.en, function(index) {
          if (index === "numbers") {
            $.timeago.settings.strings[Diaspora.I18n.language][index] = [];
          } else if (index === "minutes" ||
                     index === "hours" ||
                     index === "days" ||
                     index === "months" ||
                     index === "years") {
            $.timeago.settings.strings[Diaspora.I18n.language][index] = function(value) {
              return Diaspora.I18n.t("timeago." + index, {count: value});
            };
          } else {
            $.timeago.settings.strings[Diaspora.I18n.language][index] = Diaspora.I18n.t("timeago." + index);
          }
        });
      }
    });
  };
})();
