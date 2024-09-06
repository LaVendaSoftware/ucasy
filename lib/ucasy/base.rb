require_relative "context"
require_relative "failure"
require_relative "validators/required_attributes"

module Ucasy
  class Base < Ucasy::Callable
    class << self
      def call(context = {})
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

      validate_required_attributes!
      try(:before) if success?
      call if success?
      try(:after) if success?

      self
    rescue Failure
      self
    end

    private

    attr_reader :context

    def validate_required_attributes!
      Validators::RequiredAttributes.call(context, self.class._required_attributes, self.class)
    end

    def method_missing(method_name, *, &block)
      context.public_send(method_name)
    end

    def respond_to_missing?(method_name, include_private = false)
      context.respond_to?(method_name, include_private)
    end
  end
end
