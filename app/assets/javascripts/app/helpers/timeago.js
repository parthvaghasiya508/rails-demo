(function(){
  app.helpers.timeago = function(el) {
    el.find('time.timeago').each(function(i,e) {
      $(e).attr('title', new Date($(e).attr('datetime')).toLocaleString());
    }).timeago().tooltip();
  };
})();
