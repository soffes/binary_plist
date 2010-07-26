require "binary_plist"

Mime::Type.register BinaryPlist::MIME_TYPE, :bplist

ActionController::Renderers.add :bplist do |data, options|
  # TODO: Make this less hacky
  data = ActiveSupport::JSON.decode(ActiveSupport::JSON.encode(data, options))
  
  self.content_type ||= Mime::BPLIST
  self.response_body = BinaryPlist.encode(data)
end
