require 'test/unit'
require 'rubygems'
require 'mocha/setup'
require 'parser'
require 'test_helpers'

# Test case for the <tt>ChainReactor::Parsers::JsonParser</tt> class.
class TestJsonParser < Test::Unit::TestCase
  include ChainReactor::TestHelpers

  # Test that a ParseError is raised when an invalid JSON string is
  # passed.
  def test_parse_invalid_json_raises_error
    parser = ChainReactor::Parsers::JsonParser.new get_logger
    ex = assert_raise ChainReactor::ParseError do
      parser.parse("not a json",[],false)
    end
    assert_match( /not a valid JSON/, ex.message)
  end

  # Test that a ParseError is raised when a JSON with invalid keys is
  # passed.
  def test_parse_wrong_json_raises_error
    parser = ChainReactor::Parsers::JsonParser.new get_logger
    ex = assert_raise ChainReactor::RequiredKeyError do
      parser.parse('{"key1":"value","key2":"value"}',['monkey'],false)
    end
    assert_match(/Required key 'monkey'/, ex.message)
  end

  # Test that a valid JSON string returns a cause object with correct
  # data.
  def test_parse_valid_json_returns_hash
    name = "A name"
    type = "A type"
    json = "{\"name\":\"#{name}\",\"type\":\"#{type}\"}"
    parser = ChainReactor::Parsers::JsonParser.new get_logger
    cause = parser.parse(json,[],false)
    assert_equal name, cause['name']
    assert_equal type, cause['type']
  end

  # Test that a valid JSON string returns a cause object with correct
  # data.
  def test_parse_valid_json_returns_hash_with_symbol_keys
    name = "A name"
    type = "A type"
    json = "{\"name\":\"#{name}\",\"type\":\"#{type}\"}"
    parser = ChainReactor::Parsers::JsonParser.new get_logger
    cause = parser.parse(json,[],true)
    assert_equal name, cause[:name]
    assert_equal type, cause[:type]
  end
end
