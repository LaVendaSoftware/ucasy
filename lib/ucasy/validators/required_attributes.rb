module Ucasy::Validators
  class RequiredAttributes < Ucasy::Callable
    def initialize(context, required_attributes, klass)
      @context = context
      @required_attributes = required_attributes
      @klass = klass
    end

    def call
      @required_attributes.each do |attribute|
        next if @context.respond_to?(attribute)

        raise ArgumentError, "You must set '#{attribute}' variable in '#{@klass}'"
      end
    end
  end
end
