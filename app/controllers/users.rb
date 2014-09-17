get '/users/new' do
    @user = User.new
  	erb :"users/new"
  end

  post '/users' do
  	@user = User.new(:email                 => params[:email],
  							     :password              => params[:password],
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
    @user = User.first(params[:email_forgotten_password])
    @user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    @user.password_token_timestamp = Time.now
    @user.save!
    send_email(@user.email.to_str, @user.password_token)
    erb :"users/forgotten_password"
    flash[:notice] = "An email has been sent to your address."
  end

  get '/users/reset_password/:token' do
    @token = params[:token]
    session[:token] = @token
    erb :"users/reset_password"
  end

  post '/users/reset_password/:token' do
    @user = User.first(session[:token])
    #puts @user.password
    @user.update(:password              => params[:new_password],
                :password_confirmation => params[:confirm_new_password])
    @user.save!
    #puts @user.password
    
  end
