module Workers
  class DeletePostFromService < Base
    sidekiq_options queue: :high

    def perform(service_id, opts)
      service = Service.find_by_id(service_id)
      opts = HashWithIndifferentAccess.new(opts)
      service.delete_from_service(opts)
    end
  end
end
