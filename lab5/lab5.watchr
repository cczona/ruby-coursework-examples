## USAGE: $ watchr thisfile.watchr

files=%w{test.rb lab4.rb lab4.cgi}

files.each do |filename|

  watch filename do  |m| 

    # FIXME: run tests against approximation of CCSF environment
    # specific_ruby="/Users/cczona/.rvm/rubies/ruby-1.9.1-p431/bin/ruby -I.:lib:test -rubygems -e  "%w[test/unit test/test_helper.rb test/test_watchr.rb].each { |f| require f }\""
    
    specific_ruby="ruby"
    
    puts growl_it=` \
    date;
    echo;
    bundle exec ruby #{m[0]}  --verbose | \
    grep -v PASS | \
    sed -E -e \"s/test_[0-9]+_(should_)?//g\" | \
    grep -v \"^(Loaded|Started|Finished)\" \
    ` # CLOSING BACKTICK; NOT A STRAY CHARACTER
    
    puts growl_it
    growl_it=growl_it.split("\n")[-2].split(", ")[2..4].join(' ')
    growl_it.gsub! /\e\[[\d;]*m/, ''
    system("growlnotify -m #{__FILE__ + ' ' + growl_it}")
  end
end