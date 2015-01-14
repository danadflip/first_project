module Review
  class Server < Sinatra::Base

# Configuration


    configure :development do
      register Sinatra::Reloader
      $redis = Redis.new
    end

# Routes

    get ('/') do
      redirect to('/reviews')
    end

    get ('/reviews') do
      @reviews = reviews.sort_by {|review| review["date"]}
      render(:erb, :index, :layout => :default)
    end

    get ('/reviews/new') do

      render(:erb, :new, :layout => :default)
    end












  end #Server
end #Review
