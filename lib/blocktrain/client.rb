module Blocktrain
  class Client

    def self.results query, method = 'search', index = 'train_data'
      r = Curl::Easy.http_post(endpoint(method, index), query.to_json)
      JSON.parse r.body_str
    end

    def self.endpoint(method, index)
      "#{url}/#{index}/_#{method}"
    end

    def self.url
      ENV['ES_URL']
    end

  end
end
