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
    end
  end

end
