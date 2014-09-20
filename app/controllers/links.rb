post '/links' do
  	url = params["url"]
  	title = params["title"]
  	user = User.get(:id => session[:user_id])
  	tags = params["tags"].split(" ").map do |tag|
  		Tag.first_or_create(:text => tag)
  	end
  	Link.create(:url => url, :title => title, :tags => tags, :user => user)
  	redirect to('/')
  end

  get '/links/new' do
  	erb :"/links/new"
  end