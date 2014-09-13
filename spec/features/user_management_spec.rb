require 'spec_helper'

feature "User signs up" do
	
	scenario "when being logged out" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario "with a password that doesn't match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Sorry, your passwords don't match")
	end

	scenario "with an email that is already registered" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect{ sign_up }.to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end

end

require_relative 'helpers/session'

include SessionHelpers

feature 'User signs in' do

	before(:each) do
		User.create(:email => "test@test.com",
								:password => 'test',
								:password_confirmation => 'test')
	end

	scenario "with correct credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'test')
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario "with incorrect credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'wrong')
		expect(page).not_to have_content("Welcome, test@test.com")
	end
	
end

feature 'User signs out' do

	before(:each) do
		User.create(:email => "test@test.com",
								:password => 'test',
								:password_confirmation => 'test')
	end

	scenario 'while being signed in' do
		sign_in('test@test.com', 'test')
		click_button "Sign out"
		expect(page).to have_content("Goodbye!")
		expect(page).not_to have_content("Welcome, test@test.com")
	end

end

feature 'User resets password' do

	before(:each) do
		@user = User.create(
							:email => 'test@test.com',
							:password => 'test',
							:password_confirmation => 'test',
							:password_token => 'test_token',
							:password_token_timestamp => 'test_stamp')
	end

	scenario 'while on the login page' do
		visit('/sessions/new')
		click_link("Forgotten your password?")
		expect(page).to have_content("Please enter your email address so that we can send you a unique code to reset your password.")
	end

	scenario 'create token' do
		expect(User.first('test@test.com').password_token).to eq 'test_token'
		visit('/forgotten_password')
		expect(page).to have_content('Email:')
		fill_in 'email_forgotten_password', :with => @user.email
		click_button 'Submit'
		expect(User.first('test@test.com').password_token).not_to eq 'test_token'
		
	end

	scenario 'reset password' do
		old_password = @user.password_digest
		visit('/users/reset_password/test_token')
		expect(page).to have_content("Please enter your new password.")
		fill_in 'new_password', :with => 'new_test'
		fill_in 'confirm_new_password', :with => 'new_test'
		click_button 'Submit'
		expect(User.first('test@test.com').password_digest == old_password).to be false

	end

end













