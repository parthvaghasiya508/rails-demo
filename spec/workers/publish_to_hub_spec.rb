describe Workers::PublishToHub do
  describe ".perform" do
    it "calls pubsubhubbub" do
      url = "http://example.com/public/username.atom"
      m = double

      expect(m).to receive(:publish).with(url)
      expect(Pubsubhubbub).to receive(:new).with(AppConfig.environment.pubsub_server).and_return(m)
      Workers::PublishToHub.new.perform(url)
    end
  end
end
