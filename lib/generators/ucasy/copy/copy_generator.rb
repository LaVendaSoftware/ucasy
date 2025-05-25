module Ucasy
  class CopyGenerator < Rails::Generators::Base
    source_root File.expand_path("../../..", __dir__)

    desc "Copy Ucasy code to application"
    def create_use_case_base
      system "bin/rails g ucasy:install"

      directory "ucasy", use_case_path
    end

    private

    def use_case_path
      Rails.root.join("app/#{generator_folder_name}/ucasy")
    end

    def generator_folder_name
      return Ucasy::GENERATOR_FOLDER_NAME if defined?(Ucasy::GENERATOR_FOLDER_NAME)

      Ucasy::DEFAULT_GENERATOR_FOLDER_NAME
    end
  end
end
