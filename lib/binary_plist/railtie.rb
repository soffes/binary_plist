require "binary_plist"

module BinaryPlist
  autoload :BinaryPlistResponder, 'binary_plist/responder'
  
  if defined? Rails::Railtie
    require "rails"
    class Railtie < Rails::Railtie
      initializer "binary_plist.add_plist_responder" do
        ActiveSupport.on_load :active_record do
          BinaryPlist::Railtie.insert
        end
      end
    end
  end

  class Railtie
    def self.insert
      Mime::Type.register BinaryPlist::MIME_TYPE, :plist
      
      ActionController::Renderers.add :plist do |data, options|
        # TODO: Make this less hacky
        data = ActiveSupport::JSON.decode(ActiveSupport::JSON.encode(data, options))
      
        self.content_type ||= Mime::PLIST
        self.response_body = BinaryPlist.encode(data)
      end
    end
  end
end
