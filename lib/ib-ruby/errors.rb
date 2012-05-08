module Ib

  # Error handling
  class Error < RuntimeError
  end

  class ArgumentError < ArgumentError
  end

  class LoadError < LoadError
  end

end # module IB

### Patching Object with universally accessible top level error method
def error message, type=:standard, backtrace=nil
  e = case type
        when :standard
          Ib::Error.new message
        when :args
          Ib::ArgumentError.new message
        when :load
          Ib::LoadError.new message
      end
  e.set_backtrace(backtrace) if backtrace
  raise e
end

