### USAGE: $ ruby thisfile
### Optional: MiniTest options can be passed in as arguments to filename, e.g. $ ruby thisfile -- -v
### To see all MiniTest options, use $ ruby -r minitest/autorun -e '' -- --help

begin
  # coverage must be before anything else!
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
  gem 'minitest', '> 1.4.2' # load after require of stdlib minitest
  require 'metric_fu'
rescue LoadError => e
  puts e
end

PROJECT_ROOT=File.expand_path('../', File.dirname(__FILE__))
$:<< PROJECT_ROOT# load path

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