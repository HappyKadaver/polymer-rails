module Polymer
  module Rails
    module Processors
      class Component
        def self.call(input)
          input[:data] = `vulcanize --inline-scrips --inline-css --strip-comments "#{input[:filename]}"`
        end
      end
    end
  end
end
