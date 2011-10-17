require_relative './test-prelude'

# testing CGI API because documentation (erroneously, apparently) suggests these methods went away after Ruby 1.8.7 and resurfaced elsewhere in 1.9.2.  So existance in 1.9.1 cannot be assumed.  Plus, get alerted if/when deploying on 1.9.2

describe "CGI library" do

  it 'CGI library loads successfully' do
    Module.constants.must_include :CGI
  end

  it 'necessary methods are available in this version of the CGI library' do
    [:new, :unescape].each do |method|
      CGI.public_methods.must_include method
    end

    [:params].each do |method|
      CGI.new.methods.must_include method
    end
  end

end