get '/users/new' do
    @user = User.new
  	erb :"users/new"
  end

  post '/users' do
  	@user = User.new(:email => params[:email],
  							:password => params[:password],
                :password_confirmation => params[:password_confirmation])
    if @user.save
  	 session[:user_id] = @user.id
  	 redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

  get '/forgotten_password' do
    erb :"users/forgotten_password"
  end

  post '/forgotten_password' do
    user = User.first(:email => params[:email_forgotten_password])
    user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save!
    erb :"users/forgotten_password"
    flash[:notice] = "An email has been sent to your address."
  end