# require 'ib-ruby/ib'

if defined?(Rails) && Rails.respond_to?('env')
  require 'ib-ruby/db'
end
  
module IB
  # IB Models can be either database-backed, or not
  # By default there is no DB backend, unless specifically requested
  # require 'ib-ruby/db' 
  # to make all IB models database-backed
  DB ||= false
  
  if defined?(Rails) && Rails.respond_to?('env')
    require 'ib-ruby/engine'
  else
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
IbRuby = IB

