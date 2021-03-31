describe LikeSignature, type: :model do
  it_behaves_like "signature data" do
    let(:relayable_type) { :like }
  end
end
