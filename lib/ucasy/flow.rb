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
        ActiveRecord::Base.transaction { execute_services }
      else
        execute_services
      end

      self
    end

    private

    def execute_services
      self.class._service_classes.each do |service_class|
        service_class.call(context)

        next unless self.class.transactional?

        raise ActiveRecord::Rollback if failure?
      end
    end
  end
end
