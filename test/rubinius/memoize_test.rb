require 'test_helper'
require 'rubinius/memoize'

module Rubinius
  describe Memoize do
    let(:klass) { Class.new }

    it 'memoizes a method with arity zero' do
      klass.class_eval """
        def self.counter; @counter ||= 0; end
        def self.counter=(c); @counter = c; end

        memoize def foo
          self.class.counter += 1
          3
        end
      """

      obj = klass.new
      obj.foo.must_equal 3
      klass.counter.must_equal 1
      obj.foo.must_equal 3
      klass.counter.must_equal 1
    end

    describe 'when trying to memoize a method with arity > 0' do
      it 'raises an ArgumentError' do
        lambda {
          klass.class_eval """
          memoize def foo(a)
          end
          """
        }.must_raise ArgumentError
      end
    end

    it 'can expire memoized methods' do
      klass.class_eval """
      def self.counter; @counter ||= 0; end
      def self.counter=(c); @counter = c; end

      memoize def foo
        self.class.counter += 1
        3
      end
      """

      obj = klass.new
      obj.foo.must_equal 3
      klass.counter.must_equal 1

      Memoize.expire(obj, :foo)

      obj.foo.must_equal 3
      klass.counter.must_equal 2
    end
  end
end
