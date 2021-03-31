module Workers
  class DeferredRetraction < Base
    sidekiq_options queue: :high

    def perform(user_id, retraction_data, recipient_ids, opts)
      user = User.find(user_id)
      subscribers = Person.where(id: recipient_ids)
      object = Retraction.new(retraction_data.deep_symbolize_keys, subscribers)
      opts = HashWithIndifferentAccess.new(opts)

      Diaspora::Federation::Dispatcher.build(user, object, opts).dispatch
    end
  end
end
