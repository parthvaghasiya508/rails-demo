app.pages.Settings = Backbone.View.extend({
  initialize: function() {
    $(".settings-visibility").tooltip({placement: "top"});
    $(".profile-visibility-hint").tooltip({placement: "top"});
    $("[name='profile[public_details]']").bootstrapSwitch();

    new Diaspora.TagsAutocomplete("#profile_tag_string", {
      preFill: gon.preloads.tagsArray
    });
    new Diaspora.ProfilePhotoUploader();

    this.viewAspectSelector = new app.views.PublisherAspectSelector({
      el: $(".aspect_dropdown"),
      form: $("#post-default-aspects")
    });
  }
});
