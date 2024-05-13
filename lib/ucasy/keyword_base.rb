module Ucasy
  class KeywordBase
    include Ucasy::Callable

    def self.call(**)
      new(**).call
    end
  end
end
