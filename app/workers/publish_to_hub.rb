module Workers
  class PublishToHub < Base
    sidekiq_options queue: :medium

    def perform(sender_atom_url)
      Pubsubhubbub.new(AppConfig.environment.pubsub_server.get).publish(sender_atom_url)
    end
  end
end
