require 'test/unit'
require 'rubygems'
require 'mocha/setup'
require 'parsers/parser'
require 'parsers/xml_simple_parser'
require 'helpers'

def parse
  @file.read
end

# Test case for the <tt>ChainReactor::Parsers::XmlSimpleParser</tt> class.
class TestXmlSimpleParser < Test::Unit::TestCase
  include ChainReactor::TestHelpers

  # Test that a ParseError is raised when an invalid xml string is
  # passed.
  def test_parse_non_xml_raises_error
    parser = ChainReactor::Parsers::XmlSimpleParser.new get_logger
    ex = assert_raise ChainReactor::Parsers::ParseError do
      parser.parse("not an xml string",[],false)
    end
    assert_match( /not a valid XML string/, ex.message)
  end
  
  # Test that a ParseError is raised when an invalid xml string is
  # passed.
  def test_parse_invalid_xml_raises_error
    parser = ChainReactor::Parsers::XmlSimpleParser.new get_logger
    ex = assert_raise ChainReactor::Parsers::ParseError do
      parser.parse("<data>",[],false)
    end
    assert_match( /not a valid XML string/, ex.message)
  end

  # Test that a ParseError is raised when a xml with invalid keys is
  # passed.
  def test_parse_wrong_xml_raises_error
    parser = ChainReactor::Parsers::XmlSimpleParser.new get_logger
    ex = assert_raise ChainReactor::Parsers::RequiredKeyError do
      parser.parse('<data><key1>value</key1><key2>value</key2></data>',['monkey'],false)
    end
    assert_match(/Required key 'monkey'/, ex.message)
  end

  # Test that a valid xml string returns a cause object with correct
  # data.
  def test_parse_valid_xml_returns_hash
    name = "A name"
    type = "A type"
    xml = "<data><name>#{name}</name><type>#{type}</type></data>"
    parser = ChainReactor::Parsers::XmlSimpleParser.new get_logger
    cause = parser.parse(xml,[],false)
    assert_equal name, cause['name'].first
    assert_equal type, cause['type'].first
  end

  # Test that a valid xml string returns a cause object with correct
  # data.
  def test_parse_valid_xml_returns_hash_with_symbol_keys
    name = "A name"
    type = "A type"
    xml = "<data><name>#{name}</name><type>#{type}</type></data>"
    parser = ChainReactor::Parsers::XmlSimpleParser.new get_logger
    cause = parser.parse(xml,[],true)
    assert_equal name, cause[:name].first
    assert_equal type, cause[:type].first
  end
end
