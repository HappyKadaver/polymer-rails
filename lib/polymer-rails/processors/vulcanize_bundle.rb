module Polymer
  module Rails
    module Processors
      class VulcanizeBundle < ::Sprockets::Bundle
        def self.process_bundle_reducers(assets, reducers)
          processed = ::Sprockets::Bundle.process_bundle_reducers(assets, reducers)
          return processed unless assets.any?

          pre_vulcanize = Tempfile.new('pre-vulcanize')
          pre_vulcanize.write processed[:data]
          pre_vulcanize.close
          processed[:data] = `vulcanize --inline-scripts --inline-css --strip-comments --strip-exclude ".*" #{redirects} "#{pre_vulcanize.path}"`
          pre_vulcanize.unlink

          return processed
        end

        private
        def self.redirects
          "--redirect \"#{::Rails.root.join 'app', 'assets', 'components', 'foo'}|#{::Rails.root.join 'vendor', 'assets', 'components'}\""
        end
      end
    end
  end
end