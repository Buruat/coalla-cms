require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module FileUploads
      class InstallGenerator < ActiveRecord::Generators::Base
        argument :name, type: :string, default: ""
        source_root File.expand_path("../templates", __FILE__)
        class_option :copy, type: :boolean, default: false, description: "Copy all files to project"

        def copy_files
          migration_template "migration.rb", "db/migrate/create_file_upload.rb"
        end
      end
    end
  end
end
