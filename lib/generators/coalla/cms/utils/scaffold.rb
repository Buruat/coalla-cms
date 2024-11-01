module Coalla
  module Cms
    module Utils
      module Scaffold
        def cms_select_name(klass)
          (([:title, :name, :caption] & klass.new.methods) << :id).first
        end
      end
    end
  end
end