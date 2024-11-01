module Coalla
  class DefaultPolicy
    def initialize(context)
      @context = context
    end

    def action_enabled?(action, options = {})
      return true
    end

    def field_enabled?(field, options = {})
      return true
    end

    def section_enabled?(section, options = {})
      return true
    end

    def sanitize_params(params, options = {})
      return params
    end

    protected

    attr_reader :context
  end

  mattr_accessor :policy
  @@policy = DefaultPolicy
end