module Review
  class Server < Sinatra::Base



    configure :development do
      register Sinatra::Reloader
      $redis = Redis.new
    end

    configure :production do
      $redis = Redis.new({url: ENV['REDISTOGO_URL']})
    end


    get('/') do
      redirect to('/reviews')
    end

    get('/reviews') do
      # reversing order for newest first
      ids = $redis.lrange("review_ids", 0, -1).reverse
      @reviews = ids.map do |id|
        $redis.hgetall("review:#{id}")
      end
      render :erb, :reviews, layout: :default
    end

    get('/reviews/new') do
      render :erb, :new, layout: :new
    end

    post('/reviews') do
      id = $redis.incr("review_id")
      # koopa:#{id} need it to reference
      $redis.hmset(
        "review:#{id}",
        "user_name", params["user_name"],
        "restaurant", params["restaurant"],
        "neighborhood", params["neighborhood"],
        "res_image", params["res_image"],
        "review", params["review"],
        "tags", params["tags"],
        "res_date", params["res_date"],
        "quality", params["quality"],
        "price", params["price"],
        "atmosphere", params["atmosphere"],
        "service", params["service"],
        "deals", params["deals"]
        )
      $redis.rpush("review_ids", id)
      redirect to("/reviews")
    end

delete '/reviews/r/:restaurant' do
      restaurant = params[:restaurant].downcase
      ids = $redis.lrange("review_ids", 0, -1).reverse
      rest_id = ids.select do |id|
        if $redis.hget("review:#{id}", "restaurant") == params[:restaurant]
          $redis.del("review:#{@restaurant_id}")
        end
      end
      redirect('/reviews')
    end




# new review page specific to restaurant
get('/reviews/r/:restaurant') do
      ids = $redis.lrange("review_ids", 0, -1).reverse
      @restaurant = []
      @restaruant_id = params[:restaurant]
      ids.each do |id|
      if $redis.hget("review:#{id}", "restaurant") == params[:restaurant]
          @restaurant.push($redis.hgetall("review:#{id}"))
        end
      end
      render :erb, :show_restaurant, layout: :default
    end



# new review pages separated by neighborhood
    get('/reviews/n/:neighborhood') do
      ids = $redis.lrange("review_ids", 0, -1).reverse
      @neighborhood = []
      ids.each do |id|
        if $redis.hget("review:#{id}", "neighborhood") == params[:neighborhood]
          @neighborhood.push($redis.hgetall("review:#{id}"))
        end
      end
      render :erb, :show_neighborhood, layout: :default
    end

# new review pages separated by price

    get('/reviews/p/:price') do
      ids = $redis.lrange("review_ids", 0, -1).reverse
      @price = []
      ids.each do |id|
        if $redis.hget("review:#{id}", "price") == params[:price]
          @price.push($redis.hgetall("review:#{id}"))
        end
      end
      render :erb, :show_price, layout: :default
    end

# new review pages separated by quality

    get('/reviews/q/:quality') do
      ids = $redis.lrange("review_ids", 0, -1).reverse
      @quality = []
      ids.each do |id|
        if $redis.hget("review:#{id}", "quality") == params[:quality]
          @quality.push($redis.hgetall("review:#{id}"))
        end
      end
      render :erb, :show_quality, layout: :default
    end

# new review pages separated by tags

    get('/reviews/t/:tags') do
      ids = $redis.lrange("review_ids", 0, -1).reverse
      @tags = []
      ids.each do |id|
        if $redis.hget("review:#{id}", "tags") == params[:tags]
          @tags.push($redis.hgetall("review:#{id}"))
        end
      end
      render :erb, :show_tags, layout: :default
    end

# new review pages separated by user

    get('/reviews/u/:user_name') do
      ids = $redis.lrange("review_ids", 0, -1).reverse
      @user_name = []
      ids.each do |id|
        if $redis.hget("review:#{id}", "user_name") == params[:user_name]
          @user_name.push($redis.hgetall("review:#{id}"))
        end
      end
      render :erb, :show_user, layout: :default
    end



  end #Server
end #Review
