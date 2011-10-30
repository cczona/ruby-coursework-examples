#!/usr/bin/env ruby

class Generate

  def is_production?
    #  another candidate: ENV['SERVER_SIGNATURE'].match(%r{hills.ccsf.cc.ca.us})
    ( ENV["HTTP_HOST"]=="hills.ccsf.edu" || ENV["SERVER_ADDR"]=='147.144.1.2' || ENV['USER'] == 'czona' )
  end
  def path

    if is_production? #FIXME: unsandbox these!
      @path=File.expand_path('/tmp/czona/')
    else
      @path=File.expand_path('/tmp/lab6/')
    end
  end

end
