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
          appendable = (depth == 0) ? list : list.last
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
            when "begin"
              list[1..list.size-1].each do |exp|
                execute(exp)
              end
              execute(list.last)
            when "print"
              _, printable = list
              puts execute(printable)
            else
              if list.is_a? Hash
                execute(list[:lambda])
              else
                binding = env[list.first]
                raise SymbolUndefinedError, "#{list.first} is undefined." if binding.nil?
                execute(binding)
              end
            end
      ret
    end

    def execute_file(filename)
      exps = Rusp.parse(File.read(filename))
      exps.each { |exp| execute(exp) }
    end

    def env
      @@env ||= {}
    end
    
  end
end
