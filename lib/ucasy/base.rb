require_relative "context"
require_relative "failure"
require_relative "validators/validate"
require_relative "validators/required_attributes"

module Ucasy
  class Base < Ucasy::Callable
    class << self
      def call(context = {})
        new(context).perform
      end

      def validate(validator_class, validatable_attributes = nil)
        @validator_class = validator_class
        @validatable_attributes = validatable_attributes
      end

      attr_reader :validator_class, :validatable_attributes

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

      validate!
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

    def validate!
      return if self.class.validator_class.blank?

      validator = Validators::Validate.call(*validate_params)

      return if validator.valid?

      context.fail!(status: :unprocessable_entity, errors: validator.errors)
    end

    def validate_params
      [self.class.validator_class, try(self.class.validatable_attributes) || context]
    end

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
