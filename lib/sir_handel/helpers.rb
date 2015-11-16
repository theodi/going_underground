module SirHandel
  class App < Sinatra::Base
    helpers do
      def protected!
        return if ENV['RACK_ENV'] == 'test'
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end

      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? and
          @auth.basic? and
          @auth.credentials and
          @auth.credentials == [
            ENV['TUBE_USERNAME'],
            ENV['TUBE_PASSWORD']
          ]
      end
    end
  end
end
