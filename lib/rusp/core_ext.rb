module Rusp
  module CoreExt
    module String
      def numeric?
        !!self.match(/^[-]?[\d]+(\.[\d]+){0,1}$/)
      end
    end
  end
end

class String
  include Rusp::CoreExt::String
end
