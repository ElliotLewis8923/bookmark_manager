helpers do

  def current_user
    @current_user ||=User.get(session[:user_id]) if session[:user_id]
  end

  def send_email(email, token)
  	env_mailgun = ENV['MAILGUN_API_KEY']
  	env_domain = ENV['LOCAL_DOMAIN'] || 'http://localhost:9292/'
  	RestClient.post "https://api:#{env_mailgun}"\
  	"@api.mailgun.net/v2/sandbox2dd7989739724f71a533c6cbf400ba00.mailgun.org/messages",
  	:from => "Mailgun Sandbox <postmaster@sandbox2dd7989739724f71a533c6cbf400ba00.mailgun.org>",
  	:to => email,
  	:subject => 'Forgotten password',
  	:text => 'Please visit the following link to reset your password: #{env_domain}users/reset_password/#{token}'
	end

end