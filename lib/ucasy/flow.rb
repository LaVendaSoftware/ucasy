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

      def transactional
        @transactional = true
      end

      def transactional?
        @transactional || false
      end
    end

    def call
      if self.class.transactional?
        ActiveRecord::Base.transaction { services_executer }
      else
        services_executer
      end

      self
    end

    private

    def services_executer
      self.class._service_classes.each do |service_class|
        service_class.call(context)
      end
    end
  end
end
