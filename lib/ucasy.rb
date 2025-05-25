require_relative "ucasy/version"

module Ucasy
  Ucasy::DEFAULT_GENERATOR_FOLDER_NAME = "use_cases"

  autoload :Callable, "ucasy/callable"
  autoload :Context, "ucasy/context"
  autoload :Failure, "ucasy/failure"

  module Validators
    autoload :Validate, "ucasy/validators/validate"
    autoload :RequiredAttributes, "ucasy/validators/required_attributes"
  end

  autoload :Base, "ucasy/base"
  autoload :Flow, "ucasy/flow"

  class Error < StandardError
  end
end
