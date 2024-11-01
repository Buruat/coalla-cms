#encoding: utf-8
require 'shellwords'

module Coalla
  class ImageUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick

    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # You can call this method in your model
    # For example
    # before_save if: :image_changed? do
    #   image.set_image_properties
    # end
    def set_image_properties
      return if !model || !file

      model.send(setter(:file_name), file.filename) if model.respond_to?(setter(:file_name))
      model.send(setter(:size), file.size) if model.respond_to?(setter(:size))
      model.send(setter(:content_type), file.content_type) if model.respond_to?(setter(:content_type))
      if model.respond_to?(setter(:width)) && model.respond_to?(setter(:height))
        w, h = `identify -format "%wx %h" #{file.path.shellescape}`.split(/x/).map { |dim| dim.to_i }
        model.send(setter(:width), w)
        model.send(setter(:height), h)
      end
    end

    # You can call this method with process in your uploader
    def watermark
      return if !model || !model.respond_to?(getter(:watermarked?)) || !model.send(getter(:watermarked?))

      manipulate! do |img|
        logo = Magick::Image.read(Rails.root.join('app/assets/images/watermark.png')).first
        img.composite(logo, Magick::SouthEastGravity, 0, 0, Magick::OverCompositeOp)
      end
    end

    private

    def setter(name)
      opt = model.class.uploader_options[mounted_as] || {}
      if opt[:prefixed]
        "#{mounted_as}_#{name}="
      else
        "#{name}="
      end
    end

    def getter(name)
      opt = model.class.uploader_options[mounted_as] || {}
      if opt[:prefixed]
        "#{mounted_as}_#{name}"
      else
        "#{name}"
      end
    end
  end
end