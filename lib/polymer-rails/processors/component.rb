require 'polymer-rails/component'
require "polymer-rails/processors/sprockets_processor"

module Polymer
  module Rails
    module Processors
      class Component < Polymer::Rails::SprocketsProcessor

        def process
          require_imports
        end

      private

        def require_imports
          @component.html_imports.each do |import|
            @context.require_asset absolute_asset_path(import.attributes['href'].value)
            import.remove
          end
        end

        def absolute_asset_path(file)
          search_file = file.sub(/^(\.\.\/)+/, '/').sub(/^\/*/, '')
          @@sprockets_env.paths.each do |path|
            file_list = Dir.glob( "#{File.absolute_path search_file, path }*")
            return file_list.first unless file_list.blank?
          end
          components = Dir.glob("#{File.absolute_path file, File.dirname(@context.pathname)}*")
          return components.blank? ? nil : components.first
        end
      end
    end
  end
end
