module IB
  class Engine < Rails::Engine
    config.to_prepare do
    end  
    
    initializer "ib-ruby.active_record" do |app|
      ActiveSupport.on_load :active_record do
        module ::IB
          require 'version'
          require 'extensions'
          require 'errors'
          require 'constants'
          require 'connection'

          require 'models'
          Datatypes = Models # Flatten namespace (IB::Contract instead of IB::Models::Contract)
          include Models # Legacy alias

          require 'messages'
          IncomingMessages = Messages::Incoming # Legacy alias
          OutgoingMessages = Messages::Outgoing # Legacy alias

          require 'symbols'  
        end
      end
    end
  end
end
