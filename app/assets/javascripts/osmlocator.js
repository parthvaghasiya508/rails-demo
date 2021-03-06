OSM =  {};

OSM.Locator = function(){

  var geolocalize = function(callback){
    navigator.geolocation.getCurrentPosition(function(position) {       
      var lat=position.coords.latitude,
          lon=position.coords.longitude;
      $.getJSON("https://nominatim.openstreetmap.org/reverse?format=json&lat="+lat+"&lon="+lon+"&addressdetails=3", function(data){
        return callback(data.display_name, position.coords);
      }); 
    },errorGettingPosition);
  };

  function errorGettingPosition() {
    $("#location").remove();
  }

  return {
    getAddress: geolocalize
  };
};
