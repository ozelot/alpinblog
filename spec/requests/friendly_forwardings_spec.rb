require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward the user to the requested page" do
    user = Factory(:user)
    visit edit_user_path(user)
    # The test follows automatically to the sign in page
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
    # The user should be redirected to the edit path
    response.should render_template('users/edit')
  end

end
