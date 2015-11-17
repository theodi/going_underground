module SirHandel
 class App < Sinatra::Base
   use(Rack::Conneg) do |conneg|
     conneg.set :accept_all_extensions, false
     conneg.set :fallback, :html
     conneg.provide([:html, :json])
   end

   configure do
     I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
     I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
     I18n.backend.load_translations
   end

   before do
     if negotiated?
       content_type negotiated_type
     end
   end
 end
end
