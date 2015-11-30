module Blocktrain
  class Client

    attr_reader :url, :index

    def initialize(url=nil, index=nil)
      @url = URI(url || ENV['ES_URL'])
      @index = index || ENV['ES_INDEX'] || 'train_data'
    end

    def endpoint(name)
      @url.merge("#{index}/#{name}").to_s
    end

    def search(query)
      r = Curl::Easy.http_post(endpoint('_search'), query.to_json)
      JSON.parse r.body_str
    end

  end
end
