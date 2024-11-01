require 'rails/generators/named_base'
require 'securerandom'

module Coalla
  module Cms

    class InitGenerator < Rails::Generators::NamedBase
      argument :name, type: :string
      source_root File.expand_path('../templates', __FILE__)

      def setup_names
        @name = name.underscore
      end

      def setup_common_parts
        copy_file 'locales/activerecord.ru.yml', 'config/locales/activerecord.ru.yml'
        copy_file 'locales/activerecord.en.yml', 'config/locales/activerecord.en.yml'
        copy_file 'initializers/carrierwave.rb', 'config/initializers/carrierwave.rb'
        copy_file 'schedule.rb', 'config/schedule.rb'

        remove_file 'public/index.html'
        remove_file '.gitignore'
        copy_file '.gitignore', '.gitignore'
        copy_file '.gitattributes', '.gitattributes'

        remove_file 'public/500.html'
        remove_file 'public/404.html'
        remove_file 'public/422.html'

        copy_file 'errors/500.html', 'public/500.html'
        copy_file 'errors/404.html', 'public/404.html'
        copy_file 'errors/422.html', 'public/422.html'


        template 'controllers/home_controller.rb.erb', 'app/controllers/home_controller.rb'
        empty_directory 'app/views/home'
        template 'views/home/index.html.haml.erb', 'app/views/home/index.html.haml'
        route "root to: 'home#index'"

        remove_file 'config/database.yml'
        template 'database.yml.erb', 'config/database.yml'
      end

      def setup_devise
        generate 'devise:install'
        gsub_file 'config/initializers/devise.rb', 'please-change-me-at-config-initializers-devise@example.com', "no-reply@#{name}.ru"
        gsub_file 'config/initializers/devise.rb', '# config.password_length = 6..128', 'config.password_length = 4..128'
        gsub_file 'config/initializers/devise.rb', '# config.scoped_views = false', 'config.scoped_views = true'
        gsub_file 'config/initializers/devise.rb', '# config.sign_out_all_scopes = true', 'config.sign_out_all_scopes = false'
        remove_file 'config/locales/devise.ru.yml'
        copy_file 'locales/devise.ru.yml', 'config/locales/devise.ru.yml'
      end

      def setup_application_file
        gsub_file 'config/application.rb', '# config.i18n.default_locale = :de', 'config.i18n.default_locale = :ru'
        gsub_file 'config/application.rb', "# config.time_zone = 'Central Time (US & Canada)'", "config.time_zone = 'Moscow'"
        application "config.action_dispatch.default_headers = {'X-Frame-Options' => 'ALLOWALL'}"
      end

      def configure_mailer
        gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do |match|
          c = <<-CONFIG

  config.action_mailer.default_url_options = {host: 'localhost', port: 3000}
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.asset_host = "http://localhost:3000"
          CONFIG
          match << c
        end
      end

      def configure_assets
        gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do |match|
          c = <<-CONFIG

  config.action_mailer.default_url_options = {host: 'localhost', port: 3000}
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.asset_host = "http://localhost:3000"
          CONFIG
          match << c
        end

        template 'assets.rb', 'config/initializers/assets.rb'
      end

      def include_common_gems
        add_source 'http://gems.coalla.ru'

        gem 'russian'
        gem 'acts_as_list'
        gem 'enumerize'
        gem 'remotipart'
        gem 'rmagick', require: false
        gem 'cancancan'
        gem 'sitemap_generator'
        gem 'whenever'
        gem 'tzinfo-data'
        gem 'uglifier'
        gem 'sprockets'
        gem 'meta-tags'

        gem_group :development do
          gem 'ruby-prof'
          gem 'thin'
          gem 'haml-rails'
          gem 'letter_opener'
          gem 'byebug'
          gem 'web-console'
          gem 'spring'
          gem 'awesome_print', require: 'ap'
          gem 'annotate'
        end

        gem_group :production, :staging do
          gem 'exception_notification'
        end
      end

      private

      def generate_password(ln=15)
        SecureRandom.base64(ln).tr('+/=lIO0', 'pqrsxyz')
      end

    end
  end
end


