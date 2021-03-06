$(document).ready(function() {
  function publisherContent(params) {
    if (params.content) {
      return params.content;
    }

    var content = params.title + " - " + params.url;
    if (params.notes.length > 0) {
      content += " - " + params.notes;
    }
    return content;
  }

  var content = publisherContent(gon.preloads.bookmarklet);
  if (content.length > 0) {
    $("#status_message_text").val(content);
  }
});
