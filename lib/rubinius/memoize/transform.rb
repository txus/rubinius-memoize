RBX = Rubinius::ToolSets::Runtime

module Rubinius
  module Memoize
    include RBX::AST

    class Transform < Send
      attr_accessor :meth

      transform :default, :memoize, "Memoization transform"

      def self.match?(line, receiver, name, arguments, privately)
        if name == :memoize
          m = arguments.body.first
          if m.is_a?(RBX::AST::Define)
            transform = new line, receiver, name, privately
            transform.meth = m
            transform
          end
        end
      end

      def bytecode(g)
        pos(g)

        unless meth.arguments.total_args.zero?
          raise ArgumentError, "#{g.file}:#{g.line} -- memoize only accepts argumentless methods"
        end

        m = RBX::AST::Define.new(
          meth.line,
          meth.name,
          RBX::AST::Block.new(
            meth.body.line,
            rewritten_method_body
          )
        )
        m.arguments = meth.arguments
        m.bytecode(g)
      end

      private

      def rewritten_method_body
        o = Object.new

        name = meth.name
        body = meth.body

        o.singleton_class.send(:define_method, :bytecode) do |g|
          # Check the cache
          g.push_self
          g.push_literal :"@__memoized_#{name}"
          g.send :__instance_variable_defined_p__, 1

          # If the method is already memoized, just go to the end and return the
          # memoized value.
          fin = g.new_label
          g.git fin

          # Otherwise, execute the method body.
          body.bytecode(g)

          # And memoize the value for further calls.
          g.set_ivar :"@__memoized_#{name}"
          g.ret

          fin.set!
          g.push_ivar :"@__memoized_#{name}"
        end

        [o]
      end
    end
  end
end
