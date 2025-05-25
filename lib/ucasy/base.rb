module Ucasy
  class Base < Ucasy::Callable
    class << self
      def call(context = {})
        new(context).perform
      end

      def validate(validator_class, *validator_attribute_keys)
        @validator_class = validator_class
        @validator_attribute_keys = validator_attribute_keys
      end

      attr_reader :validator_class, :validator_attribute_keys

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

      validator = Validators::Validate.call(self.class.validator_class, validator_attributes)

      if validator.valid?
        validator.to_context.each do |key, value|
          context.send(:"#{key}=", value)
        end
      else
        context.fail!(status: :unprocessable_entity, message: validator.message, errors: validator.errors)
      end
    end

    def validator_attributes
      return context.to_h if self.class.validator_attribute_keys.blank?

      context.to_h.slice(*self.class.validator_attribute_keys)
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
