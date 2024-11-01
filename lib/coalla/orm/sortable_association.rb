module Coalla
  module SortableAssociation
    def sortable_association(*args)
      unless respond_to?(:sortable_associations)
        class_attribute :sortable_associations, instance_writer: false
        self.sortable_associations = []
      end

      self.sortable_associations += args

      class_eval do
        def assign_nested_attributes_for_collection_association(association_name, attributes_collection)
          association_class = self.class.reflect_on_association(association_name).klass
          if sortable_associations.include?(association_name) && association_class.attribute_names.include?('position')
            attributes_collection.each_with_index do |(key, value), index|
              if key.is_a?(Hash)
                key[:position] = index
              elsif value.is_a?(Hash)
                value[:position] = index
              end
            end
          end
          super
        end
      end
    end
  end
end

ActiveRecord::Base.extend(Coalla::SortableAssociation)