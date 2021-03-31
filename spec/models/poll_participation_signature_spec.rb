describe PollParticipationSignature, type: :model do
  it_behaves_like "signature data" do
    let(:relayable_type) { :poll_participation }
  end
end
