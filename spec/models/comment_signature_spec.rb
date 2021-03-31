describe CommentSignature, type: :model do
  it_behaves_like "signature data" do
    let(:relayable_type) { :comment }
  end
end
