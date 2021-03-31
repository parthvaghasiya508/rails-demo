describe 'disconnecting a contact', :type => :request do
  it 'removes the aspect membership' do
    @user = alice
    @user2 = bob

    expect{
      @user.disconnect(@user.contact_for(@user2.person))
    }.to change(AspectMembership, :count).by(-1)
  end
end
