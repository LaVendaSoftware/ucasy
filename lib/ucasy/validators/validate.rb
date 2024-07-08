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

    def valid?
      !invalid?
    end

    def invalid?
      @validator&.errors || true
    end

    def errors
      @validator&.errors || []
    end
  end
end
