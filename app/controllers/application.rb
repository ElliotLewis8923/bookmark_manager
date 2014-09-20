	get '/' do
  	@links = Link.all(:user => User.get(session[:user_id]))
  	erb :index
  end