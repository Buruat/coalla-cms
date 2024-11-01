module Coalla
  module PageSlider
    def slider(collection_name, options = {})
      class_name = options.delete(:class_name) || 'SliderImage'
      slider_type = slider_type(collection_name)
      has_many collection_name, -> { where(slider_type: slider_type).order(:position) }, foreign_key: :container_slider_id, dependent: :destroy, class_name: class_name
      accepts_nested_attributes_for collection_name, allow_destroy: true
      define_method "sorted_#{collection_name}" do
        send(collection_name).sort_by(&:position)
      end
      sortable_association(collection_name.to_sym)
    end

    def slider_type(collection_name)
      # Workaround for STI - save parent class name for using in subclass
      @@slider_metadata ||= []
      self.ancestors.each do |klazz|
        slider_type = "#{klazz.name && klazz.name.sub('::', '__')}_#{collection_name}"
        return slider_type if @@slider_metadata.include? slider_type
        break if klazz == ActiveRecord::Base
      end
      slider_type = "#{self.name && self.name.sub('::', '__')}_#{collection_name}"
      @@slider_metadata << slider_type
      slider_type
    end
  end
end

ActiveRecord::Base.extend(Coalla::PageSlider)