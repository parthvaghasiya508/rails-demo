app.models.Contact = Backbone.Model.extend({
  initialize : function() {
    this.aspectMemberships = new app.collections.AspectMemberships(this.get("aspect_memberships"));
    if (this.get("person")) {
      this.person = new app.models.Person(this.get("person"));
      this.person.contact = this;
    }
  },

  inAspect : function(id) {
    return this.aspectMemberships.any(function(membership) { return membership.belongsToAspect(id); });
  }
});
