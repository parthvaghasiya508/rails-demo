app.views.Stream = app.views.InfScroll.extend({

  initialize: function() {
    this.stream = this.model;
    this.collection = this.stream.items;

    this.postViews = [];

    this.setupNSFW();
    this.setupInfiniteScroll();
    this.markNavSelected();
    this.initInvitationModal();
  },

  postClass : app.views.StreamPost,

  setupNSFW : function(){
    function reRenderPostViews() {
      _.map(this.postViews, function(view){ view.render() });
    }
    app.currentUser.bind("nsfwChanged", reRenderPostViews, this);
  },

  markNavSelected : function() {
    var activeStream = Backbone.history.fragment;
    var streamSelection = $("#stream_selection");
    streamSelection.find("[data-stream]").removeClass("selected");
    streamSelection.find("[data-stream='" + activeStream + "']").addClass("selected");
  },

  initInvitationModal : function() {
    $(".invitations-link").click(function() {
      app.helpers.showModal("#invitationsModal");
    });
  }
});
