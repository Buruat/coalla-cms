#encoding: utf-8
module Coalla
  class AdminStructure
    Section = Struct.new(:name, :path, :icon, :description, :counter, :show_menu_counter, :creation_path, :section_name) do

      def show_menu_counter?
        show_menu_counter.present?
      end

    end

    Separator = Struct.new(:title)

    CONFIG_FILE_NAME = 'structure.rb'

    attr_accessor :sections

    def initialize(controller, routes)
      @controller = controller
      @sections = []
      self.class.include(routes.url_helpers)
      load_sections_from_config
    end

    def menu_items
      dashboard_item = Section.new(I18n.t('admin.common.dashboard'), admin_dashboard_path, 'glyphicon glyphicon-align-left')
      [dashboard_item] + @sections
    end

    def sections
      @sections.find_all { |section| section.is_a?(Section) }
    end

    private

    def load_sections_from_config
      config_path = Rails.root.join('config', CONFIG_FILE_NAME).to_s
      if File.exist?(config_path)
        instance_eval(File.read(config_path), config_path)
      end
    end

    # Options:
    # creation_path - false or path string
    def section(section_reference, options = {})
      path = options.delete(:path)
      icon = options.delete(:icon)
      description = options.delete(:description)
      counter = options.delete(:counter)
      show_menu_counter = options.delete(:show_menu_counter)
      creation_path = options.delete(:creation_path)
      if section_reference.is_a?(Class)
        section_name = section_reference.model_name.human
        path = send("admin_#{section_reference.model_name.route_key}_path") unless path
        counter = ->() { section_reference.count } unless counter
        creation_path = send("new_admin_#{section_reference.model_name.singular}_path") if creation_path.nil?
      else
        section_name = section_reference
      end
      return unless policy.section_enabled?(options[:section_name], options)
      @sections << Section.new(section_name, path, icon, description, counter, show_menu_counter, creation_path, options[:section_name])
    end

    def lookup_section(section_references = I18n.t('activerecord.models.lookup'), category = nil, options = {})
      default_options = {path: send('admin_lookups_index_path', category: category),
                         icon: 'glyphicon glyphicon-wrench',
                         description: ''}.merge(options)
      section(section_references, default_options)
    end

    def meta_tags_section(section_references = I18n.t('activerecord.models.meta_tags'), options = {})
      default_options = {path: send('admin_meta_tags_path'),
                         icon: 'glyphicon glyphicon-tag',
                         description: ''}.merge(options)
      section(section_references, default_options)
    end

    def separator(title)
      @sections << Separator.new(title)
    end

    def policy
      @controller.policy
    end
  end
end