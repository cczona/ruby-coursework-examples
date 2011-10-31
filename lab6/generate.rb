#!/usr/bin/env ruby

if Module.const_defined?(:DATA) # external tests can't see this
  SOURCE=DATA
  POSITION=SOURCE.pos
else
  SOURCE=File.new(__FILE__)
  POSITION=File.read(SOURCE).match(/^__END__.*$/).offset(0)[1]+1
end

class Generate
  ALLOWED_CHARACTERS=('a'..'z').to_a + ('A'..'Z').to_a  + ('0'..'9').to_a  << '-' << '_'

  def initialize
    $:.unshift script_directory # add app base directory to load path
  end

  def data
    SOURCE.pos=POSITION
    SOURCE.read
  end

  def is_production?
    #  another candidate: ENV['SERVER_SIGNATURE'].match(%r{hills.ccsf.cc.ca.us})
    ( ENV["HTTP_HOST"]=="hills.ccsf.edu" || ENV["SERVER_ADDR"]=='147.144.1.2' || ENV['USER'] == 'czona' )
  end

  def script_directory
    if is_production? #FIXME: unsandbox these!
      File.expand_path('/tmp/czona/')
    else
      File.expand_path('/tmp/lab6/')
    end
  end

  def valid_input?
    unless ARGV.class == Array        ; raise Exception, "That's weird.  ARGV isn't an array for some reason.";end
    if (ARGV.length < 1)              ; raise ArgumentError, 'Must provide one argument';end
    if (ARGV.length > 1)              ; raise ArgumentError, "Just one argument, please";end
    unless (ARGV[0].class == String)  ; raise ArgumentError, "Sorry, the argument must be a string";end
    unless (sane?)                    ; raise ArgumentError, "Sorry, the name '#{ARGV[0]}' is not allowed. Stick to strings consisting of ASCII letters, numbers, underscores, and hyphens.";end
    return true
  end

  def sane?
    letters=ARGV[0].split('').uniq # beware: uniq! returns nil when no changes are made
    return false if letters.size == 0
    passable=ALLOWED_CHARACTERS
    letters.each { |ltr| return false unless passable.include? ltr }
    return true
  end

  def app_name
    if valid_input?
      ARGV[0].to_s
    else
      raise RuntimeError "Invalid input somehow was introduced"
    end
  end

  def new_app_directory
    File.expand_path('./' + app_name, script_directory)
  end

end


__END__
