module Coalla
  class MetaImageUploader < ImageUploader
    version :main do
      resize_to_limit 1024, 1024
    end
  end
end