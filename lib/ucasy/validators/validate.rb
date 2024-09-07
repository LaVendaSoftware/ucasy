module Ucasy::Validators
  class Validate < Ucasy::Callable
    def initialize(klass, attributes)
      @klass = klass
      @attributes = attributes
    end

    def call
      @validator = @klass.new(@attributes) if @klass.present?

      self
    end

    def message
      @validator.try(:message_error)
    end

    def to_context
      @validator.try(:to_context) || {}
    end

    def valid?
      @validator&.valid? || false
    end

    def invalid?
      !valid?
    end

    def errors
      @validator&.errors || []
    end
  end
end
