module Blocktrain
  class Client

    def self.results query, method = 'search'
      r = Curl::Easy.http_post(endpoint(method), query.to_json)
      JSON.parse r.body_str
    end

    def self.endpoint(method)
      "#{url}/#{index}/_#{method}"
    end

    def self.url
      ENV['ES_URL']
    end

    def self.index
      ENV['ES_INDEX'] || 'train_data'
    end
  end
end
