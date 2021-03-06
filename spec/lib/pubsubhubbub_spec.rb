describe Pubsubhubbub do
  describe '#publish' do
    it 'posts the feed to the given hub' do
      hub = "http://hubzord.com/"
      feed = 'http://rss.com/dom.atom'
      body = {'hub.url' => feed, 'hub.mode' => 'publish'}

      stub_request(:post, "http://hubzord.com/").to_return(:status => [202, 'you are awesome'])
      expect(Pubsubhubbub.new(hub).publish(feed)).to be_success
    end
  end
end
