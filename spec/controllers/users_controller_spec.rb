describe UsersController, :type => :controller do
  include_context :gon

  before do
    @user = alice
    sign_in @user, scope: :user
    allow(@controller).to receive(:current_user).and_return(@user)
  end

  describe '#export_profile' do
    it 'queues an export job' do
      expect(@user).to receive :queue_export
      post :export_profile
      expect(request.flash[:notice]).to eql(I18n.t('users.edit.export_in_progress'))
      expect(response).to redirect_to(edit_user_path)
    end
  end

  describe "#download_profile" do
    it "downloads a user's export file" do
      @user.perform_export!
      get :download_profile
      expect(response).to redirect_to(@user.export.url)
    end
  end

  describe '#export_photos' do
    it 'queues an export photos job' do
      expect(@user).to receive :queue_export_photos
      post :export_photos
      expect(request.flash[:notice]).to eql(I18n.t('users.edit.export_photos_in_progress'))
      expect(response).to redirect_to(edit_user_path)
    end
  end

  describe '#download_photos' do
    it "redirects to user's photos zip file"  do
      @user.perform_export_photos!
      get :download_photos
      expect(response).to redirect_to(@user.exported_photos_file.url)
    end
  end

  describe '#public' do
    it 'renders xml if atom is requested' do
      sm = FactoryGirl.create(:status_message, :public => true, :author => @user.person)
      get :public, :username => @user.username, :format => :atom
      expect(response.body).to include(sm.text)
    end

    it 'renders xml if atom is requested with clickalbe urls' do
      sm = FactoryGirl.create(:status_message, :public => true, :author => @user.person)
      @user.person.posts.each do |p|
        p.text = "Goto http://diasporaproject.org/ now!"
        p.save
      end
      get :public, :username => @user.username, :format => :atom
      expect(response.body).to include('a href')
    end

    it 'includes reshares in the atom feed' do
      reshare = FactoryGirl.create(:reshare, :author => @user.person)
      get :public, :username => @user.username, :format => :atom
      expect(response.body).to include reshare.root.text
    end

    it 'do not show reshares in atom feed if origin post is deleted' do
      post = FactoryGirl.create(:status_message, :public => true);
      reshare = FactoryGirl.create(:reshare, :root => post, :author => @user.person)
      post.delete
      get :public, :username => @user.username, :format => :atom
      expect(response.code).to eq('200')
    end

    it 'redirects to a profile page if html is requested' do
      get :public, :username => @user.username
      expect(response).to be_redirect
    end

    it 'redirects to a profile page if mobile is requested' do
      get :public, :username => @user.username, :format => :mobile
      expect(response).to be_redirect
    end
  end

  describe '#update' do
    before do
      @params  = { :id => @user.id,
                  :user => { :diaspora_handle => "notreal@stuff.com" } }
    end

    it "doesn't overwrite random attributes" do
      expect {
        put :update, @params
      }.not_to change(@user, :diaspora_handle)
    end

    it 'renders the user edit page' do
      put :update, @params
      expect(response).to render_template('edit')
    end

    describe 'password updates' do
      let(:password_params) do
        {:current_password => 'bluepin7',
         :password => "foobaz",
         :password_confirmation => "foobaz"}
      end

      let(:params) do
        {id: @user.id, user: password_params, change_password: 'Change Password'}
      end

      it "uses devise's update with password" do
        expect(@user).to receive(:update_with_password).with(hash_including(password_params))
        allow(@controller).to receive(:current_user).and_return(@user)
        put :update, params
      end
    end

    describe 'language' do
      it 'allow the user to change his language' do
        old_language = 'en'
        @user.language = old_language
        @user.save
        put(:update, :id => @user.id, :user =>
            { :language => "fr"}
           )
        @user.reload
        expect(@user.language).not_to eq(old_language)
      end
    end

    describe "color_theme" do
      it "allow the user to change his color theme" do
        old_color_theme = "original"
        @user.color_theme = old_color_theme
        @user.save
        put(:update, id: @user.id, user: {color_theme: "dark_green"})
        @user.reload
        expect(@user.color_theme).not_to eq(old_color_theme)
      end
    end

    describe 'email' do
      it 'disallow the user to change his new (unconfirmed) mail when it is the same as the old' do
        @user.email = "my@newemail.com"
        put(:update, :id => @user.id, :user => { :email => "my@newemail.com"})
        @user.reload
        expect(@user.unconfirmed_email).to eql(nil)
      end

      it 'allow the user to change his (unconfirmed) email' do
        put(:update, :id => @user.id, :user => { :email => "my@newemail.com"})
        @user.reload
        expect(@user.unconfirmed_email).to eql("my@newemail.com")
      end

      it 'informs the user about success' do
        put(:update, :id => @user.id, :user => { :email => "my@newemail.com"})
        expect(request.flash[:notice]).to eql(I18n.t('users.update.unconfirmed_email_changed'))
        expect(request.flash[:error]).to be_blank
      end

      it 'informs the user about failure' do
        put(:update, id: @user.id, user: {email: "mynewemailcom"})
        expect(request.flash[:error]).to eql(I18n.t('users.update.unconfirmed_email_not_changed'))
        expect(request.flash[:notice]).to be_blank
      end

      it 'allow the user to change his (unconfirmed) email to blank (= abort confirmation)' do
        put(:update, :id => @user.id, :user => { :email => ""})
        @user.reload
        expect(@user.unconfirmed_email).to eql(nil)
      end

      it 'sends out activation email on success' do
        expect(Workers::Mail::ConfirmEmail).to receive(:perform_async).with(@user.id).once
        put(:update, :id => @user.id, :user => { :email => "my@newemail.com"})
      end
    end

    describe "email settings" do
      UserPreference::VALID_EMAIL_TYPES.each do |email_type|
        context "for #{email_type}" do
          it "lets the user turn off mail" do
            par = {id: @user.id, user: {email_preferences: {email_type => "true"}}}
            expect {
              put :update, par
            }.to change(@user.user_preferences, :count).by(1)
          end

          it "lets the user get mail again" do
            @user.user_preferences.create(email_type: email_type)
            par = {id: @user.id, user: {email_preferences: {email_type => "false"}}}
            expect {
              put :update, par
            }.to change(@user.user_preferences, :count).by(-1)
          end
        end
      end
    end

    describe 'getting started' do
      it 'can be reenabled' do
        put :update, user: {getting_started: true}
        expect(@user.reload.getting_started?).to be true
      end
    end
  end

  describe '#privacy_settings' do
    it "returns a 200" do
      get 'privacy_settings'
      expect(response.status).to eq(200)
    end
  end

  describe '#edit' do
    it "returns a 200" do
      get 'edit', :id => @user.id
      expect(response.status).to eq(200)
    end

    it 'displays community spotlight checkbox' do
      AppConfig.settings.community_spotlight.enable = true
      get 'edit', :id => @user.id
      expect(response.body).to include('input name="user[show_community_spotlight_in_stream]"')
    end

    it 'hides community spotlight checkbox' do
      AppConfig.settings.community_spotlight = false
      get 'edit', :id => @user.id
      expect(response.body).not_to include('input name="user[show_community_spotlight_in_stream]"')
    end

    it 'set @email_pref to false when there is a user pref' do
      @user.user_preferences.create(:email_type => 'mentioned')
      get 'edit', :id => @user.id
      expect(assigns[:email_prefs]['mentioned']).to be false
    end

    it "does not allow token auth" do
      sign_out :user
      bob.reset_authentication_token!
      get :edit, :auth_token => bob.authentication_token
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe '#destroy' do
    it 'does nothing if the password does not match' do
      expect(Workers::DeleteAccount).not_to receive(:perform_async)
      delete :destroy, :user => { :current_password => "stuff" }
    end

    it 'closes the account' do
      expect(alice).to receive(:close_account!)
      delete :destroy, :user => { :current_password => "bluepin7" }
    end

    it 'enqueues a delete job' do
      expect(Workers::DeleteAccount).to receive(:perform_async).with(anything)
      delete :destroy, :user => { :current_password => "bluepin7" }
    end
  end

  describe '#confirm_email' do
    before do
      @user.update_attribute(:unconfirmed_email, 'my@newemail.com')
    end

    it 'redirects to to the user edit page' do
      get 'confirm_email', :token => @user.confirm_email_token
      expect(response).to redirect_to edit_user_path
    end

    it 'confirms email' do
      get 'confirm_email', :token => @user.confirm_email_token
      @user.reload
      expect(@user.email).to eql('my@newemail.com')
      expect(request.flash[:notice]).to eql(I18n.t('users.confirm_email.email_confirmed', :email => 'my@newemail.com'))
      expect(request.flash[:error]).to be_blank
    end

    it 'does NOT confirm email with wrong token' do
      get 'confirm_email', :token => @user.confirm_email_token.reverse
      @user.reload
      expect(@user.email).not_to eql('my@newemail.com')
      expect(request.flash[:error]).to eql(I18n.t('users.confirm_email.email_not_confirmed'))
      expect(request.flash[:notice]).to be_blank
    end
  end

  describe 'getting_started' do
    it 'does not fail miserably' do
      get :getting_started
      expect(response).to be_success
    end

    it 'does not fail miserably on mobile' do
      get :getting_started, :format => :mobile
      expect(response).to be_success
    end

    context "with inviter" do
      [bob, eve].each do |inviter|
        sharing = !alice.contact_for(inviter.person).nil?

        context sharing ? "when sharing" : "when don't share" do
          it "preloads data using gon for the aspect memberships dropdown" do
            alice.invited_by = inviter
            get :getting_started
            expect_gon_preloads_for_aspect_membership_dropdown(:inviter, sharing)
          end
        end
      end
    end
  end
end
