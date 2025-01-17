module Coalla
  module Cms
    module Utils
      module Orm
        def model_contents
          <<-CONTENT
  devise :database_authenticatable, :rememberable, :validatable
          CONTENT
        end

        def model_exists?
          File.exists?(File.join(destination_root, model_path))
        end

        def migration_exists?(table_name)
          Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_add_admin_role_to_#{table_name}.rb$/).first
        end

        def migration_path
          @migration_path ||= File.join('db', 'migrate')
        end

        def model_path
          @model_path ||= File.join('app', 'models', "#{file_path}.rb")
        end
      end
    end
  end
end