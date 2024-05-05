require "ostruct"

module Ucasy
  class Context < OpenStruct
    def self.build(context = {})
      (self === context) ? context : new(context)
    end

    def fail!(options = {})
      options.each { |key, value| self[key.to_sym] = value }
      @failure = true
      raise Failure, self
    end

    def failure?
      @failure || false
    end

    def success?
      !failure?
    end
  end
end
