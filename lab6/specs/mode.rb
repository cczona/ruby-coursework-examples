require 'helper'

class String
def convert_base(from, to)
  self.to_i(from).to_s(to)
end
end

class Fixnum
  def convert_base(from,to)
    self.to_s.to_i(from).to_s(to).to_i
  end
end

describe "whatever" do

  it 'fooz' do
    '1010'.convert_base(2, 10).must_equal '10'
    1010.convert_base(2,10).must_equal 10
    711.convert_base(10,8).must_equal 1307
    # 17095.convert_base(10,8).split[-4,-1].join.must_equal 711
    0711.convert_base(8,10).must_equal 1307
  end

end
  
