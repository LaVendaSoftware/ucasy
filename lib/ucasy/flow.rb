module Ucasy
  class Flow < Base
    class << self
      def flow(*ucases)
        @ucases = ucases
      end

      def ucases
        @ucases || []
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
        ActiveRecord::Base.transaction { execute }
      else
        execute
      end

      self
    end

    private

    def execute
      self.class.ucases.each do |ucase|
        ucase.call(context)

        next unless self.class.transactional?

        raise ActiveRecord::Rollback if failure?
      end
    end
  end
end
