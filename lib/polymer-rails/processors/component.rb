module Polymer
  module Rails
    module Processors
      class Component
        def self.call(input)
          input[:data] = `vulcanize --inline-scripts --inline-css --strip-comments --redirect "#{::Rails.root.join 'app', 'assets', 'components', 'foo'}|#{::Rails.root.join 'vendor', 'assets', 'components'}" "#{input[:filename]}"`
        end
      end
    end
  end
end
