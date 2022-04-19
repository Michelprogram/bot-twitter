require 'oauth'
require 'json'
require 'twitter'
require 'fileutils'


class Twitter_Bot
  def initialize()

    @Api_Key = "/"
    @Api_Secret_Key = "/"

    @Acces_Token = "/"
    @Acces_Token_Secret = "/"

    @Token = ""

    @Photo = ""
    @Message = ""

  end


  def Post_image()

    Random_Name()
    Random_Photo()

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = @Api_Key
      config.consumer_secret     = @Api_Secret_Key
      config.access_token        = @Acces_Token
      config.access_token_secret = @Acces_Token_Secret
    end

    client.update_with_media("#{@Message}", File.new("/home/pi/Twitter/Photo/#{@Photo}"))

    Moove_Photo()

  end



  private

  def Random_Photo()
    FileUtils.cd("/home/pi/Twitter/Photo")
    nb_files = Dir.glob("*").length
    @Photo = Dir.glob("*")[rand(nb_files)]

  end

  def Moove_Photo()
    FileUtils.mv("/home/pi/Twitter/Photo/#{@Photo}","/home/pi/Twitter/Photo_used")
  end

  def Random_Name()
    name = "Choliere".split("")
    [rand(8),rand(8),rand(8),rand(8)].each do |value|
      name[value] = name[value].capitalize
    end
    @Message = name.shuffle.join("")
  end

  def self.next_15_hours()
    current_time = Time.now()
    puts "Heure actuel #{current_time}"
    hours = 24 - current_time.hour
    puts "Heure restante avant 00 #{hours}"
    min = current_time.min
    puts "Minutes  #{min}"
    sec = current_time.sec
    puts "Secondes #{sec}"
    next_day  = (current_time + (3600*hours) - (60*min) - sec) + (3600*15)

    return (next_day - current_time).round(0)

  end
  
end


=begin
  def Update_Token()
    uri = URI("https://api.twitter.com/oauth2/token")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@Api_Key, @Api_Secret_Key)
    request.set_form_data("grant_type" => "client_credentials")

    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == "https") do |http|
      JSON.parse(http.request(request).body)
    end
    @Token = response["access_token"]
  end

  def Post_Tweet(texte)
    url_texte = "https://api.twitter.com/1.1/statuses/update.json?status=cho"

    token_hash = {
      :oauth_token => @Acces_Token,
      :oauth_token_secret => @Acces_Token_Secret
    }

    consumer = OAuth::Consumer.new(@Api_Key, @Api_Secret_Key, { :site => "https://api.twitter.com", :scheme => :header })
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )

    response = access_token.request(:post, url_image)

    puts response.body

  end
=end
