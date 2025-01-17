class SiteMetaTags < ActiveRecord::Base
  self.table_name = 'meta_tags'

  mount_uploader :image, Coalla::MetaImageUploader
  mount_uploader :og_image, Coalla::MetaImageUploader

  validates_uniqueness_of :identifier

  def self.default_tags
    where(identifier: :default).first
  end

  def identifier_text
    identifier == 'default' ? 'Тэги по умолчанию' : identifier
  end
end