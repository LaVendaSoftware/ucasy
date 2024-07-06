require_relative "context"
require_relative "failure"

module Ucasy
  class Base < Ucasy::Callable
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
      try(:before) if success?
      call if success?
      try(:after) if success?

      self
    rescue Failure
      self
    end

    private

    attr_reader :context

    def validate_context!
      self.class._required_attributes.each do |attribute|
        next if context.respond_to?(attribute)

        raise ArgumentError, "You must set '#{attribute}' variable in '#{self.class}'"
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
