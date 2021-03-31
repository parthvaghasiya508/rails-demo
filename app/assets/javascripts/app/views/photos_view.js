app.views.Photos = app.views.InfScroll.extend({
  className: "clearfix row",

  postClass : app.views.Photo,

  initialize : function() {
    this.stream = this.model;
    this.collection = this.stream.items;

    // viable for extraction
    this.stream.fetch();
    this.setupInfiniteScroll();
  },

  postRenderTemplate: function(){
    var photoAttachments = $("#main_stream > div");
    if(photoAttachments.length > 0) {
      new app.views.Gallery({ el: photoAttachments });
    }
  }
});
