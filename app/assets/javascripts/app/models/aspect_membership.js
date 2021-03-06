/**
 * this model represents the assignment of an aspect to a person.
 * (only valid for the context of the current user)
 */
app.models.AspectMembership = Backbone.Model.extend({
  urlRoot: "/aspect_memberships",

  belongsToAspect: function(aspectId) {
    var aspect = this.get("aspect");
    return aspect && aspect.id === aspectId;
  }
});
