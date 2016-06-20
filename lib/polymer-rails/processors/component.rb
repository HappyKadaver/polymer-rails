require 'open3'

module Polymer
  module Rails
    module Processors
      class Component
        def self.call(input)
          result = ''

          cmd = "vulcanize --inline-scrips --inline-css --strip-comments \"#{calculate_redirects}\""
          Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
            stdin.write input[:data]

            result = stdout.read
          end

          input[:data] = result
        end

        private
        def self.calculate_redirects
          return '' if ::Rails.application.assets.paths.count <= 1

          default_asset_path = ::Rails.root.join 'app', 'assets', 'components'

          redirects = ::Rails.application.assets.paths.map do |p|
            "\"#{default_asset_path}|#{File.join p, 'components'}\""
          end

          "--redirect #{redirects.join ' --redirect'}"
        end
      end
    end
  end
end
