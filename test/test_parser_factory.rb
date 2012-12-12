require 'test/unit'
require 'rubygems'
require 'parser_factory'
require 'test_helpers'
require 'dummy_parser'

# Test case for the <tt>ChainReactor::ParserFactory</tt> class.
class TestParserFactory < Test::Unit::TestCase
  include ChainReactor::TestHelpers

  def test_get_parser_gives_json_parser_with_symbol
    parser = ChainReactor::ParserFactory.get_parser(:json,get_logger)
    assert_kind_of ChainReactor::Parsers::JsonParser, parser
  end

  def test_get_parser_gives_dummy_parser_with_symbol
    parser = ChainReactor::ParserFactory.get_parser(:dummy,get_logger)
    assert_kind_of ChainReactor::Parsers::DummyParser, parser
  end

  def test_get_parser_gives_dummy_parser_with_string
    parser = ChainReactor::ParserFactory.get_parser('dummy',get_logger)
    assert_kind_of ChainReactor::Parsers::DummyParser, parser
  end
  
end
