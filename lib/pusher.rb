class Pusher

  HOST = 'localhost'
  PORT = '8081'

  def initialize(key)
    @key = key
  end

  def [](channel_id)
    Channel.new(@key, channel_id)
  end

  class Channel
    def initialize(key, id)
      @http = RestClient::Resource.new "http://#{Pusher::HOST}:#{Pusher::PORT}/app/#{key}/channel/#{id}"
    end

    def trigger(event_name, data)
      data = data.to_json if data.respond_to?(:to_json) # ActiveSupport dependency: ugly
      begin
        @http.post(
        :event => event_name,
        :data => data
        )
      rescue StandardError => e
        handle_error e
      end
    end

    private

    def handle_error(e)
      puts e.inspect
    end

  end

end