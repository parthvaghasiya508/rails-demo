(function() {
  app.helpers.Shortcuts = function(evtname, fn) {
    var textAcceptingInputTypes = [
      "color",
      "date",
      "datetime",
      "datetime-local",
      "email",
      "month",
      "number",
      "password",
      "range",
      "search",
      "select",
      "text",
      "textarea",
      "time",
      "url",
      "week"
    ];

    $("body").on(evtname, function(event) {
      // make sure that the user is not typing in an input field
      if (textAcceptingInputTypes.indexOf(event.target.type) === -1) {
        fn(event);
      }
    });
  };
})();
