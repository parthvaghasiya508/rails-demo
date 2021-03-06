/* Modified version of https://gitorious.org/statusnet/mainline/blobs/master/plugins/DirectionDetector/jquery.DirectionDetector.js */
(function() {
  var DirectionDetector = function() {
    var self = this;
    this.binds = [];
    this.cleaner = new RegExp("@[^ ]+|^RT[: ]{1}| RT | RT: |[♺♻:]+", "g");

    this.subscribe("widget/ready", function() {
      self.updateBinds();

      self.globalSubscribe("stream/scrolled", function() {
				self.updateBinds();
      });
    });

    this.isRTL = app.helpers.txtDirection.isRTL;

    this.updateBinds = function() {
      $.each(self.binds, function(index, bind) {
				bind.unbind("keyup", self.updateDirection);
      });

      self.binds = [];

      $("textarea, input[type='text'], input[type='search']").each(self.bind);
    };

    this.bind = function() {
      self.binds.push(
				$(this).bind("keyup", self.updateDirection)
      );
    };

    this.updateDirection = function() {
      var textArea = $(this),
          cleaned = textArea.val().replace(self.cleaner, "").replace(/^[ ]+/, "");

      app.helpers.txtDirection.setCssFor(cleaned, textArea);
    };
  };

  Diaspora.Widgets.DirectionDetector = DirectionDetector;
})();
