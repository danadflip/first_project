# Configuration

    # TODO remember to add these to production ie heroku
    APP_ID          = ENV["FACEBOOK_OAUTH_ID"]
    APP_SECRET_KEY  = ENV["FACEBOOK_OAUTH_SECRET"]
    SCOPES          = 'email public_profile' # available secret API date
    AUTH_URI        = 'https://www.facebook.com/dialog/oauth'
    TOKEN_URI       = 'https://graph.facebook.com/oauth/access_token'
    API_PROFILE_URI = 'https://graph.facebook.com/me'
    REDIRECT_URI    = 'http://localhost:9292/oauth'

    configure :development do
      register Sinatra::Reloader
      enable :logging
      enable :method_override
      enable :sessions
      $redis = Redis.new
    end


# ########################
#   # "State" methods
# ########################


#   def session_state
#     session[:state] ||= SecureRandom.urlsafe_base64
#   end

#   def clear_session_state
#     session[:state] = nil
#   end

#   def request_state_equals_stored_state
#     params[:state] == session[:state]
#   end

# ########################
#   # OAuth methods
#   ########################

#   def auth_uri_with_query_params_for
#     query_params = "?" + URI.encode_www_form({
#       :response_type => 'code',
#       :client_id     => APP_ID,
#       :scope         => SCOPES,
#       :state         => session_state
#     })
#     AUTH_URI + query_params
#   end

#   def get_access_token_for
#     authorization_code = params[:code]
#     token_uri          = TOKEN_URI

#     request_params = {
#       :code          => authorization_code,
#       :client_id     => APP_ID,
#       :client_secret => APP_SECRET_KEY,
#       :grant_type    => "authorization_code"
#     }
#       query_string = URI.encode_www_form(request_params)
#       response = RestClient.get("#{token_uri}?#{query_string}")
#       response = URI.decode_www_form(response).inject({}) { |h, a| h[a[0]] = a[1]; h }
#       session[:access_token] = response["access_token"]
#     end
#   end

# ########################
#   # Authorized API call (after OAuth complete!)
#   ########################

#   def get_user_info_from
#     response = RestClient.get(
#       API_PROFILE_URI,
#       {:Authorization => "Bearer #{session[:access_token]}"}
#     )
#     user_info = JSON.parse(response)
#       session[:current_user] = {
#         :email    => user_info["email"],
#         :name     => user_info["name"],
#         :provider => provider
#       }
#     end
#   end


   #  def get_user_info
   #    response = HTTParty.get("graph.facebook.com/bgolub?fields=id,name,picture")
   #      :headers => {
   #       "Authorization" => "Bearer #{session[:access_token]}",
   #       "User-Agent"    => "Progress notes"
   #       }
   #       )
   #   session[:email]       = response["email"]
   #   session[:name]        = response["name"]
   #   session[:provider]    = "Facebook"
   # end




# # Routes

    # get('/') do
    #   # https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.2#login
    #   @login_url = "https://www.facebook.com/dialog/oauth?client_id=#{APP_ID}&redirect_uri=#{REDIRECT_URI}&scopes=#{SCOPES}"
    #   @logout_url = ('/logout')
    #   render :erb, :index
    # end


    # get('/oauth') do
    #   code = params["code"]
    #   url = "https://graph.facebook.com/oauth/access_token?client_id=#{APP_ID}&redirect_uri=#{REDIRECT_URI}&client_secret=#{APP_SECRET_KEY}&code=#{code}"
    #   response = HTTParty.get url
    #   access_cheese, expires = response.split("&")
    #   access_token = access_cheese.split("=")[1]
    #   session[:access_token] = access_token
    #   binding.pry
    #   # TODO store access token or just get user name and store that in session?
    #   redirect to('/reviews')
    # end


    # get('/logout') do
    #   session[:name] = session[:access_token] = nil

    #   redirect to('/')
    # end



    # get ('/reviews') do
    #   @reviews = reviews.sort_by {|review| review["date"]}
    #   render(:erb, :index, :layout => :default)
    # end
