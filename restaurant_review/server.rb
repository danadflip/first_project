module Review
  class Server < Sinatra::Base

# Configuration

    # TODO remember to add these to production ie heroku
    APP_ID          = ENV["FACEBOOK_OAUTH_ID"]
    APP_SECRET_KEY  = ENV["FACEBOOK_OAUTH_SECRET"]
    SCOPES          = 'email,public_profile' # available secret API date
    AUTH_URI        = 'https://www.facebook.com/dialog/oauth'
    TOKEN_URI       = 'https://graph.facebook.com/oauth/access_token'
    API_PROFILE_URI = 'https://graph.facebook.com/me'
    REDIRECT_URI    = 'http://localhost:9292/oauth'

    configure :development do
      register Sinatra::Reloader
      $redis = Redis.new
    end

# Routes

    get('/') do
      # https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.2#login
      @login_url = "https://www.facebook.com/dialog/oauth?client_id=#{APP_ID}&redirect_uri=#{REDIRECT_URI}&scopes=#{SCOPES}"
      # @logout_url = ('/logout')
      render :erb, :index
    end

    get('/oauth') do
      code = params["code"]
      url = "https://graph.facebook.com/oauth/access_token?client_id=#{APP_ID}&redirect_uri=#{REDIRECT_URI}&client_secret=#{APP_SECRET_KEY}&code=#{code}"
      response = HTTParty.get url
      access_cheese, expires = response.split("&")
      access_token = access_cheese.split("=")[1]
      session[:access_token] = access_token
      # TODO store access token or just get user name and store that in session?
      redirect to('/reviews')
    end

    get('/logout') do
      # session[:access_token] = nil
      # redirect to('/')

      (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
        self.profilePictureView.profileID = nil;
        self.nameLabel.text = @"";
        self.statusLabel.text= @"You're not logged in!";
        }
    end



    # get ('/reviews') do
    #   @reviews = reviews.sort_by {|review| review["date"]}
    #   render(:erb, :index, :layout => :default)
    # end

    get('/reviews') do
      # reversing order for newest first
      ids = $redis.lrange("review_ids", 0, -1).reverse
      @reviews = ids.map do |id|
        $redis.hgetall("review:#{id}")
      end
      render :erb, :reviews, layout: :default
    end

    get('/reviews/new') do
      render(:erb, :new, :layout => :default)
    end

    post('/reviews') do
      id = $redis.incr("review_id")
      # koopa:#{id} need it to reference
      $redis.hmset(
        "review:#{id}",
        "user_name", params["user_name"],
        "res_name", params["res_name"],
        "neighborhood", params["neighborhood"],
        "res_image", params["res_image"],
        "review", params["review"],
        "tags", params["tags"],
        "res_date", params["res_date"],
        "quality", params["quality"],
        "price", params["price"],
        "atmosphere", params["atmosphere"],
        "service", params["service"]
        )
      $redis.rpush("review_ids", id)
      redirect to("/reviews")
    end


    get('/reviews/n/:neighborhood') do
      ids = $redis.lrange("review_ids", 0, -1)
      @neighborhood = []
      ids.each do |id|
        if $redis.hget("review:#{id}", "neighborhood") == params[:neighborhood]
          @neighborhood.push($redis.hgetall("review:#{id}"))
        end
      end
      render(:erb, :show_neighborhood, :layout => :default)
    end

  end #Server
end #Review
