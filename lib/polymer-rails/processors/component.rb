require "polymer-rails/processors/sprockets_processor"
require 'open3'

module Polymer
  module Rails
    module Processors
      class Component
        DEFAULT_ASSET_PATH = Rails.root.join 'app', 'assets', 'components'

        def initialize(data)
          @data = data
        end

        def process
          result = ''

          cmd = "vulcanize --inline-scrips --inline-css --strip-comments \"#{calculate_redirects}\""
          Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
            stdin.write @data

            result = stdout.read
          end

          return result
        end

        private
        def calculate_redirects
          return '' if Rails.app.assets.paths.count <= 1

          redirects = Rails.app.assets.paths.map do |p|
            "\"#{DEFAULT_ASSET_PATH}|#{File.join p, 'components'}\""
          end

          "--redirect #{redirects.join ' --redirect'}"
        end
      end
    end
  end
end
