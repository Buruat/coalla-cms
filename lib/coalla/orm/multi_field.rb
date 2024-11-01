module Coalla
  module MultiField
    def multi_field(relation_name, options = {})
      through_collection_name = options[:through_collection_name] || "#{self.model_name.singular}_#{relation_name}".to_sym
      reflection = reflections[through_collection_name] || reflections[through_collection_name.to_s]
      through_class = reflection.klass

      self_foreign_key_method = options.fetch(:self_foreign_key_method, reflection.foreign_key.gsub('_id', ''))

      reflection = reflections[relation_name] || reflections[relation_name.to_s]
      association_model_name = reflection.source_reflection_name.to_sym
      association_foreign_key = reflection.foreign_key

      tokens_attribute_name = "#{relation_name}_tokens"
      attr_reader tokens_attribute_name

      define_method "#{tokens_attribute_name}=" do |ids|
        new_through_collection = ids.split(',').each_with_index.map do |id, position|
          item = through_class.find_or_initialize_by(self_foreign_key_method => self, association_foreign_key => id)
          item.position = position
          item
        end
        send("#{through_collection_name}=", new_through_collection)
      end

      define_method "#{relation_name}_json" do |search_field|
        association_model = association_model_name.to_s.classify.constantize
        send(through_collection_name).map do |c|
          item = association_model.find(c.send(association_foreign_key))
          {
            id: item.id,
            name: item.send(search_field)
          }
        end
      end
    end
  end
end

ActiveRecord::Base.extend(Coalla::MultiField)