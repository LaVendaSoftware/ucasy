module Ucasy
  class PositionalBase
    include Ucasy::Callable

    def self.call(*)
      new(*).call
    end
  end
end
