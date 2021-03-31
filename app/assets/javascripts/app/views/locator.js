app.views.Location = Backbone.View.extend({

  el: "#location",

  initialize: function(){
    this.render();
    this.getLocation();
  },

  render: function() {
    $("<div class=\"loader\"><div class=\"spinner\"></div></div>").appendTo(this.el);
  },

  getLocation: function(){
    var element = this.el ;

    var locator = new OSM.Locator();
    locator.getAddress(function(address, latlng){
      $(element).empty();
      $("<input/>",
        { id: "location_address",
          value: address,
          type: "text",
          class: "input-block-level form-control"
        }).appendTo($(element));

      $("#location_coords").val(latlng.latitude + "," + latlng.longitude);
    });
  }
});
