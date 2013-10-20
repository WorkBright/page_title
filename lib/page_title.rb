require "i18n"
require "forwardable"
require "page_title/version"

module PageTitle
  class Base
    # Set the controller instance. It must implement
    # the methods controller_name and action_name.
    attr_reader :controller

    # Set the main translation options.
    attr_reader :options

    extend Forwardable
    def_delegators :options, :[], :[]=, :merge!

    def initialize(controller)
      @controller = controller
      @options = {}
    end

    def to_s
      base_translation
    end

    private
    def title_translation
      I18n.t(
        title_scope,
        options.merge(scope: "titles")
      )
    end

    def base_translation
      I18n.t("titles.base", title: title_translation)
    end

    def normalized_controller_name
      controller.controller_name.gsub(%r[/], ".")
    end

    def title_scope
      [normalized_controller_name, controller.action_name].join(".")
    end
  end
end
