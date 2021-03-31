module Workers
  class PublishToHub < Base
    def perform(*_args)
      # don't publish to pubsubhubbub in cucumber
    end
  end

  class SendPrivate < Base
    def perform(*_args)
      # don't federate in cucumber
    end
  end

  class SendPublic < Base
    def perform(*_args)
      # don't federate in cucumber
    end
  end

  class PostToService < Base
    def perform(*_args)
      # don't post to services in cucumber
    end
  end

  class FetchWebfinger < Base
    def perform(*_args)
      # don't do real discovery in cucumber
    end
  end
end
