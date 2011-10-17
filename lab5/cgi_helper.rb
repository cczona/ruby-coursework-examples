# Create a module named CGI_Helper in a file named cgi_helper.rb

module CGI_Helper

  def humanize
    self.to_s.gsub(/_/, ' ').ucwords
  end

  def http_header
    "Content-type: text/html\n\n"
  end

  def doctype
    %q{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}
  end

end
