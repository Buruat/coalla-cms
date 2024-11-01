require 'rails/generators/named_base'

module Coalla
  module Cms

    class CreateAdminLoginViewGenerator < Rails::Generators::NamedBase
      argument :name, type: :string, default: ''
      source_root File.expand_path('../templates', __FILE__)

      def setup_directory
        empty_directory 'app/views/administrators/sessions'
        empty_directory 'app/controllers/admin'

        template 'views/administrators/sessions/new.html.haml', 'app/views/administrators/sessions/new.html.haml'
      end

    end
  end
end


