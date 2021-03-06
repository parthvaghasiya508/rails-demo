describe PostsHelper, :type => :helper do

  describe '#post_page_title' do
    before do
      @sm = FactoryGirl.create(:status_message)
    end

    context 'with posts with text' do
      it "delegates to message.title" do
        message = double
        expect(message).to receive(:title)
        post = double(message: message)
        post_page_title(post)
      end
    end
  end


  describe '#post_iframe_url' do
    before do
      @post = FactoryGirl.create(:status_message)
    end

    it "returns an iframe tag" do
      expect(post_iframe_url(@post.id)).to include "iframe"
    end

    it "returns an iframe containing the post" do
      expect(post_iframe_url(@post.id)).to include "src='#{AppConfig.url_to(post_path(@post))}'"
    end
  end
end
