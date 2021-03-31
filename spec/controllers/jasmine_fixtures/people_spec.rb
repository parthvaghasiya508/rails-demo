describe PeopleController, :type => :controller do
  describe '#index' do
    before do
      sign_in bob, scope: :user
    end

    it "generates a jasmine fixture with no query", :fixture => true do
      get :index
      save_fixture(html_for("body"), "empty_people_search")
    end

    it "generates a jasmine fixture trying an external search", :fixture => true do
      get :index, :q => "sample@diaspor.us"
      save_fixture(html_for("body"), "pending_external_people_search")
    end
  end
end
