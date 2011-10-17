require_relative './test-prelude'

describe "CGI_Module" do

  it 'the CGI_Helper module must have been included successfully' do
    Module.constants.include? :CGI_Helper
  end

  it 'imports all methods into Class namespace' do
    [:http_header, :humanize, :doctype].each do |name|
      Class.public_methods.must_include name
      Class.must_respond_to name
      Class.method(name).must_be_kind_of Method
      Class.method(name).to_s.must_equal("#<Method: Class(CGI_Helper)#" + name +'>')
    end

  end

  it "http_header method returns the 'Content-type: text/html' and a blank line" do
    Object.http_header.must_equal "Content-type: text/html\n\n"
  end

  # return a "humanized" string
  # i.e. table field names like "last_name" and "first_name" are to be returned as "first name" and "last name."
  it 'humanize by transforming receiver to a string then converting underscores to spaces' do
    'table_first_name'.humanize.must_equal 'table first name'
    :table_first_name.humanize.must_equal 'table first name'
  end

  # optional method: doctype(type) returns a valid HTML DOCTYPE
  # FIXME: currently type is not selectable
  it 'doctype methods returns HTML4 Transitional doctype declaration' do
    Object.doctype.must_equal %q{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}
  end

end

