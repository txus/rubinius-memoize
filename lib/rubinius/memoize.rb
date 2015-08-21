require 'rubinius/compiler'
require 'rubinius/ast'

require_relative 'memoize/transform'

module Rubinius
  module Memoize
    def self.expire(object, method)
      ivar = :"@__memoized_#{method}"
      if object.send :instance_variable_defined?, ivar
        object.send :remove_instance_variable, ivar
        true
      else
        false
      end
    end
  end
end
