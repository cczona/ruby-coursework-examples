### USAGE: $ ruby thisfile
### Optional: MiniTest options can be passed in as arguments to filename, e.g. $ ruby thisfile -- -v
### To see all MiniTest options, use $ ruby -r minitest/autorun -e '' -- --help

#coverage must be before anything else!
begin
  require 'simplecov'
  SimpleCov.start
  SimpleCov.at_exit do
    SimpleCov.result.format!
  end
  Gem.loaded_specs # UNDOCUMENTED: Ruby 1.9.1 will fail to load "gem 'minitest'" unless Gem.loaded_specs is called first.
  require 'minitest/autorun'
  require 'redgreen' # must require redgreen AFTER purdytest
  require 'minitest/reporters'
    MiniTest::Unit.runner = MiniTest::SuiteRunner.new
    if ENV['TM_PID']
      MiniTest::Unit.runner.reporters << MiniTest::Reporters::RubyMateReporter.new # sans ANSI color codes
    else
      MiniTest::Unit.runner.reporters << MiniTest::Reporters::ProgressReporter.new
      # MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new # => Turn-like
    end
# # # # Isolating turn for gem minitest issue and also because of second issue:
# # see <https://github.com/TwP/turn/issues/58>
#   require 'turn'
# end # OPTIONAL: if "gem ansi" is available, will also colorize
# # # #
  gem 'minitest', '> 1.4.2' # load after require of stdlib minitest
rescue LoadError => e
  puts e
end


# FIXME: require and require_relative complain "no such file"
# require(File.absolute_path(File.dirname(__FILE__) + '/' + "../lab5.cgi"))
# require(File.absolute_path("../lab5.cgi"))
# require_relative(File.absolute_path("../lab5.cgi"))
load(File.expand_path("../../lab5.cgi", __FILE__))


describe 'meta' do

  it "should execute tests using ruby 1.9.1" do
    RUBY_VERSION.must_equal '1.9.1'
  end

  it 'uses MiniTest gem greater than 1.4.2 to override buggy reporting by the minitest built into Ruby 1.9.1' do
    # see <http://rubygems.rubyforge.org/rubygems-update/Gem/Version.html#method-i-3C-3D-3E>
    Gem.loaded_specs.must_include 'minitest'
    Gem.loaded_specs['minitest'].version.must_be :>, Gem::Version.create('1.4.2') # NOTE, the comma is wierd but required

    # NOTE: obj.must_include test fail under Ruby 1.9.1 when gem minitest is not present (i.e. CCSF Hills),
    # The same tests pass are correctly evaluated when gem minitest > 1.4.2 is present.
    # Substitute 'obj.include?(something).must_equal true', which passes under both conditions
  end

end