module Ucasy
  class Callable
    class << self
      def call(...)
        new(...).call
      end
    end

    def call
      raise NotImplementedError, "You must implement call method"
    end
  end
end
