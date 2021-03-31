Diaspora.TagsAutocomplete = function(element, opts) {
  this.initialize(element, opts);
};

Diaspora.TagsAutocomplete.prototype = {
  constructor: Diaspora.TagsAutocomplete,

  initialize: function(element, opts) {
    this.options = {
      selectedItemProp: "name",
      selectedValuesProp: "name",
      searchObjProps: "name",
      asHtmlID: "tags",
      neverSubmit: true,
      retrieveLimit: 10,
      selectionLimit: false,
      minChars: 2,
      keyDelay: 200,
      startText: "",
      emptyText: Diaspora.I18n.t("no_results")
    };

    $.extend(this.options, opts);

    this.autocompleteInput = $(element);
    this.autocompleteInput.autoSuggest("/tags", this.options);
    this.autocompleteInput.bind("keydown", this.keydown);
  },

  keydown: function(evt) {
    if (evt.which === Keycodes.ENTER || evt.which === Keycodes.TAB || evt.which === Keycodes.SPACE) {
      evt.preventDefault();
      if ($("li.as-result-item.active").length === 0) {
        $("li.as-result-item").first().click();
      }
    }
  }
};
