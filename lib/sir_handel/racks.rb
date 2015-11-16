module SirHandel
 class App < Sinatra::Base
   use(Rack::Conneg) do |conneg|
     conneg.set :accept_all_extensions, false
     conneg.set :fallback, :html
     conneg.provide([:html, :json])
   end
   
   before do
     if negotiated?
       content_type negotiated_type
     end
   end
 end
end
