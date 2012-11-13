begin; require 'minitest/spec'; rescue LoadError => e ;puts e; end
begin; require 'minitest/autorun'; rescue LoadError => e ;puts e; end

describe Object do

  it "must execute test with Ruby 1.9.1" do
    RUBY_VERSION.must_equal '1.9.1'
  end
  
end

describe Array do
  
  before do
    @ary=%w{example}
  end
  
  it 'should find that generic array include?("example") is true' do
    @ary.include?('example').must_equal true
  end
  
  it 'should find that generic array include?("foo") is false' do
    @ary.include?("foo").must_equal false
  end
  
  it 'should be true that generic array must_include("example")' do
    @ary.must_include('example')
  end
  
  it 'should be false that generic array must_include("foo")' do
    @ary.must_include('foo')
  end
  
end
