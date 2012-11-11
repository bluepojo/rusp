require 'spec_helper'

describe Rusp do
  before do
    Rusp.env.clear
  end


  describe "#" do
    describe "parse" do
      it "should be able to define values" do
        result = Rusp.parse <<RUSP
(define b (quote c) (a (b (c))))
RUSP
        result.should == [["define", "b", ["quote", "c"], ["a", ["b", ["c"]]]]]
      end

      it "should be able to handle multiple statements" do
        result = Rusp.parse <<RUSP
(define b (quote c))
(print b)
RUSP
        result.should == [['define', 'b', ['quote', 'c']], ['print', 'b']]
      end
    end

    describe "execute" do
      it "should process the data structure and execute it" do
        Rusp.execute(['define', 'a', ['quote', 'b']])
        Rusp.env.should == {"a" => "b"}
      end

      it "should raise an error if there's an undefined symbol executed" do
        -> { Rusp.execute(['a', 'b']) }.should raise_error(Rusp::SymbolUndefinedError)
      end

      it "should store lambdas" do
        Rusp.execute(['define', 'a', ['lambda', ['print', ['quote', 'hi']]]])
        Rusp.env.should == {"a" => {lambda: ['print', ['quote', 'hi']]}}
      end

      it "should execute begin statements" do
        exp = Proc.new { |x| ['define', x, ['quote', 'abc']] }
        Rusp.execute(['begin', exp.call('a'), exp.call('b'), exp.call('c')])
        Rusp.env.keys.should == %w[a b c]
      end

      it "should return the last exp in a begin" do
        exp = Proc.new { |x| ['define', x, ['quote', 'abc']] }
        Rusp.execute(['begin', exp.call('a'), exp.call('b'), exp.call('c')]).should == 'abc'
      end
    end
  end

end
