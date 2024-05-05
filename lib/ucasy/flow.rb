module Ucasy
  class Flow < Base
    class << self
      def service_classes(*service_classes)
        @service_classes = service_classes
      end
      alias_method :flow, :service_classes

      def _service_classes
        @service_classes || []
      end
    end

    def call
      self.class._service_classes.each do |service_class|
        service_class.call(context)
      end

      self
    end
  end
end
