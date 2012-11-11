require "rusp/errors"

module Rusp
  
  LPAREN = /\(/
  RPAREN = /\)/
  WHITESPACE = /\s/

  class << self
    def parse(rusp)
      list = []
      new_token = false
      depth = 0
      rusp.each_char do |char|
        case char
        when LPAREN
          appendable = list.last || list
          (depth - 1).times do
            appendable = appendable.last
          end
          appendable << []
          depth += 1
        when RPAREN
          depth -= 1
        when WHITESPACE
          new_token = true
        else
          appendable = list.last
          (depth - 1).times do
            appendable = appendable.last
          end
          if appendable.empty? or new_token
            appendable << char
          else
            appendable.last << char
          end
          new_token = false
        end
      end
      return list
    end

    def execute(list)
      ret = case list.first
            when "define"
              _, binding, value = list
              env[binding] = execute(value)
            when "quote"
              _, quoted = list
              quoted
            when "lambda"
              _, lambda = list
              {lambda: lambda}
            when "print"
              # TODO FIXME
              pp list
              _, printable = list
              puts execute(printable)
            when Hash
              execute(list.first[:lambda])
            else
              binding = env[list.first]
              raise SymbolUndefinedError if binding.nil?
              binding
            end
      ret
    end

    def env
      @@env ||= {}
    end
    
  end
end
