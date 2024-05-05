require_relative "context"
require_relative "failure"

module Ucasy
  class Base
    class << self
      def call(context)
        new(context).perform
      end

      def required_attributes(*attributes)
        @required_attributes = attributes
      end

      def _required_attributes
        @required_attributes || []
      end
    end

    def initialize(context = {})
      @context = Context.build(context)
    end

    def perform
      return if failure?

      validate_context!
      before if respond_to?(:before)
      call
      after if respond_to?(:after)

      self
    rescue Failure
      self
    end

    def call
      raise StandardError, "You must implement call method"
    end

    private

    attr_reader :context

    def validate_context!
      self.class._required_attributes.each do |attribute|
        next if context.respond_to?(attribute)

        raise ArgumentError, "You must set '#{attribute}' variable"
      end
    end

    def method_missing(method_name, *, &block)
      context.public_send(method_name)
    end

    def respond_to_missing?(method_name, include_private = false)
      context.respond_to?(method_name, include_private)
    end
  end
end
