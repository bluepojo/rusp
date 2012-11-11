module Rusp
  class RuspError < StandardError; end;

  class RuspRuntimeError < RuspError; end
  class SymbolUndefinedError < RuspRuntimeError; end
end
