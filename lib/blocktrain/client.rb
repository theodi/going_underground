module Blocktrain
  class Client

    def self.results query
      r = Curl::Easy.http_post("#{ENV['ES_URL']}/train_data/_search", query.to_json) do |c|
        c.ssl_verify_peer = false
      end

      JSON.parse r.body_str
    end
  end
end
