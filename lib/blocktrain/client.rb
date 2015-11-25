module Blocktrain
  class Client

    def self.results query
      r = Curl::Easy.http_post(endpoint, query.to_json)
      JSON.parse r.body_str
    end

    def self.endpoint
      "#{url}/#{index}/_search"
    end

    def self.url
      ENV['ES_URL']
    end

    def self.index
      ENV['ES_INDEX'] || 'train_data'
    end
  end
end
