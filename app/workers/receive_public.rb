module Workers
  class ReceivePublic < ReceiveBase
    def perform(data, legacy=false)
      filter_errors_for_retry do
        DiasporaFederation::Federation::Receiver.receive_public(data, legacy)
      end
    end
  end
end
