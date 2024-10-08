module Ucasy
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Generates a application use case base."
    def create_use_case_base
      copy_file "use_case_base.rb.tt", use_case_path
    end

    private

    def use_case_path
      Rails.root.join("app/#{generator_folder_name}/use_case_base.rb")
    end

    def generator_folder_name
      return Ucasy::GENERATOR_FOLDER_NAME if defined?(Ucasy::GENERATOR_FOLDER_NAME)

      Ucasy::DEFAULT_GENERATOR_FOLDER_NAME
    end
  end
end
