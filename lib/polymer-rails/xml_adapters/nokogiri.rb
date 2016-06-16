require 'nokogiri'
require 'nokogumbo'

module Polymer
  module Rails
    module XmlAdapters
      class Nokogiri < Base
        HTML_OPTIONS = { save_with: ::Nokogiri::XML::Node::SaveOptions::FORMAT | ::Nokogiri::XML::Node::SaveOptions::AS_HTML | ::Nokogiri::XML::Node::SaveOptions::KEEP_HTML_BOOLEAN_ATTR_VALUES}

        # XML options for to_xml method
        XML_OPTIONS = { save_with: ::Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS }

        # Nodes that should be parsed as XML nodes
        XML_NODES = ['*[src]:not(script)']

        def parse_document data
          ::Nokogiri::HTML data
        end

        def create_node doc, name, content
          node = ::Nokogiri::XML::Node.new(name, doc)
          node.content = content
          node
        end

        def replace_node old_node, new_node
          old_node.replace new_node
        end

        def stringify doc
          xml_nodes(doc).reduce(doc.to_html(HTML_OPTIONS)) do |output, node|
            output.gsub(node.to_html(HTML_OPTIONS), node.to_xml(XML_OPTIONS)).encode(ENCODING)
          end
        end

        def css_select doc, selector
          doc.css selector
        end

        private
        def xml_nodes doc
          doc.css(XML_NODES.join(','))
        end
      end
    end
  end
end
