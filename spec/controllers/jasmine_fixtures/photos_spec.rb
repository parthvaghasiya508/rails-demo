describe PhotosController, :type => :controller do
  before do
    @alices_photo = alice.post(:photo, :user_file => uploaded_photo, :to => alice.aspects.first.id, :public => false)
    sign_in alice, scope: :user
  end

  describe '#index' do
    it "generates a jasmine fixture", :fixture => true do
      request.env['HTTP_ACCEPT'] = 'application/json'
      get :index, :person_id => alice.person.guid.to_s
      save_fixture(response.body, "photos_json")
    end
  end
end
