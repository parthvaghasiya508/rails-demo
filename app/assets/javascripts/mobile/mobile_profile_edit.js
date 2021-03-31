$(document).ready(function() {
  if (Diaspora.Page === "ProfilesEdit") {
    new Diaspora.TagsAutocomplete("#profile_tag_string", {preFill: gon.preloads.tagsArray});
    new Diaspora.ProfilePhotoUploader();
  } else if (Diaspora.Page === "UsersGettingStarted") {
    new Diaspora.TagsAutocomplete("#follow_tags", {preFill: gon.preloads.tagsArray});
    new Diaspora.ProfilePhotoUploader();
  }
});
