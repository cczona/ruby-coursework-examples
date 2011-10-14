#!/usr/bin/env ruby

module CGI_Helper
  def humanize
    self.gsub(/_/, ' ')
  end
end

class String
  include CGI_Helper 
end
