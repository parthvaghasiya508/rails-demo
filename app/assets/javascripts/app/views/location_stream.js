app.views.LocationStream = app.views.Content.extend({
  events: {
    "click .near-from": "toggleMap"
  },
  templateName: "status-message-location",

  toggleMap: function () {
    var mapContainer = this.$el.find(".mapContainer");

    if (mapContainer.hasClass("empty")) {
      var location = this.model.get("location");
      mapContainer.css("height", "150px");

      if (location.lat) {
        var map = L.map(mapContainer[0]).setView([location.lat, location.lng], 14);
        var tiles = app.helpers.locations.getTiles();

        tiles.addTo(map);

        L.marker(location).addTo(map);
        mapContainer.removeClass("empty");
        return map;
      }
    } else {
        mapContainer.toggle();
    }
  }
});
