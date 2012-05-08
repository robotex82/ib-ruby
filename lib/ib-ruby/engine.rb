module Ib
  class Engine < Rails::Engine
    config.to_prepare do
    end  
    
    initializer "ib-ruby.active_record" do |app|
      ActiveSupport.on_load :active_record do
        module ::Ib
          require 'ib-ruby/version'
          require 'ib-ruby/extensions'
          require 'ib-ruby/errors'
          require 'ib-ruby/constants'
          require 'ib-ruby/connection'

          require 'ib-ruby/models'
          Datatypes = Models # Flatten namespace (IB::Contract instead of IB::Models::Contract)
          include Models # Legacy alias

          require 'ib-ruby/messages'
          IncomingMessages = Messages::Incoming # Legacy alias
          OutgoingMessages = Messages::Outgoing # Legacy alias

          require 'ib-ruby/symbols'  
        end
      end
    end
  end
end
