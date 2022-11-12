require 'middleman-syntax/formatters'

module Middleman
  module Syntax
    module Highlighter
      mattr_accessor :options

      # A helper module for highlighting code
      def self.highlight(code, language=nil, opts={})
        lang_lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText
        lang_tag = lang_lexer.tag
        if options[:escape]
          # Use the Escape lexer if user passed :escape => true
          Rouge::Formatter.enable_escape!
          lexer = Rouge::Lexers::Escape.new(start: '{{{', end: '}}}', lang: lang_tag)
        else
          lexer = lang_lexer
        end

        highlighter_options = options.to_h.merge(opts)
        highlighter_options[:css_class] = [ highlighter_options[:css_class], lang_tag ].join(' ')
        lexer_options = highlighter_options.delete(:lexer_options)

        formatter = Middleman::Syntax::Formatters::HTML.new(highlighter_options)
        formatter.format(lexer.lex(code, lexer_options))
      end
    end
  end
end
