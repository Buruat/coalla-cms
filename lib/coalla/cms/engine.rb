module Coalla
  module Cms
    class Engine < ::Rails::Engine
      require 'active_support/i18n'
      I18n.load_path += Dir[File.expand_path('../../../config/locales/*.yml', __FILE__)]

      initializer :init_orm do
        ActiveSupport.on_load :active_record do
          require 'coalla/orm/sortable_association'
          require 'coalla/orm/page_slider'
          require 'coalla/orm/multi_field'
          require 'coalla/orm/sanitized'
        end
      end
    end
  end
end