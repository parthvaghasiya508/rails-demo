(function(){
  app.helpers.dateFormatter = {
    parse:function (dateString) {
      return new Date(dateString).getTime() || this.parseISO8601UTC(dateString || "");
    },

    parseISO8601UTC:function (dateString) {
      var iso8601_utc_pattern = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(.(\d{3}))?Z$/
        , time_components = dateString.match(iso8601_utc_pattern)
        , timestamp = time_components && Date.UTC(time_components[1], time_components[2] - 1, time_components[3],
          time_components[4], time_components[5], time_components[6], time_components[8] || 0);

      return timestamp || 0;
    }
  };
})();
