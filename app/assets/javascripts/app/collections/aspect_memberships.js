app.collections.AspectMemberships = Backbone.Collection.extend({
  model: app.models.AspectMembership,

  findByAspectId: function(id) {
    return this.find(function(membership) { return membership.belongsToAspect(id); });
  }
});
