describe Diaspora::Federated::Base do
  class Foo
    include Diaspora::Federated::Base
  end

  let(:foo) { Foo.new }

  describe "#object_to_receive" do
    it "returns self" do
      expect(foo.object_to_receive).to eq(foo)
    end
  end

  describe "#subscribers" do
    it "throws an error if the including module does not redefine it" do
      expect { foo.subscribers }.to raise_error(/override subscribers/)
    end
  end
end
