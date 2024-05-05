require_relative "ucasy/version"
require_relative "ucasy/base"
require_relative "ucasy/flow"

module Ucasy
  Ucasy::DEFAULT_GENERATOR_FOLDER_NAME = "use_cases"

  class Error < StandardError
  end
end
