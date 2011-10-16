require_relative './test-prelude'

describe "String class" do

  before do
    @str=String.new('table_first_name')
  end

  # CGI_Helper module should contain method humanize(string)
  it 'has String method humanize which is defined in module CGI_Helper' do
    @str.must_respond_to :humanize
    @str.method(:humanize).to_s.must_equal '#<Method: String(CGI_Helper)#humanize>'
  end

  # return a "humanized" string
  # i.e. table field names like "last_name" and "first_name" are to be returned as "first name" and "last name."
  it 'should humanize strings by transforming underscores to spaces' do
    @str.humanize.must_equal 'table first name'
  end

end
