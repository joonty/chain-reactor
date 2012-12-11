require 'test/unit'
require 'rubygems'
require 'chainfile_parser'
require 'test_helpers'

# Test case for the <tt>ChainReactor::ChainfileParser</tt> class.
class TestChainfileParser < Test::Unit::TestCase
  include ChainReactor::TestHelpers

  def test_single_reaction_is_added_to_reactor
    chain = <<-chain
    react_to('192.168.0.1') { |data| puts data.inspect }
    chain

    parser = ChainReactor::ChainfileParser.new(File.new(chain),get_logger)
    reactor = parser.parse
    assert_equal 1, reactor.reactions_for('192.168.0.1').length
  end

  def test_multiple_reactions_are_added_to_reactor
    chain = <<-chain
    react_to('192.168.0.1') { |data| puts data.inspect }
    react_to('192.168.0.2') { |data| puts data.inspect }
    react_to('192.168.0.2') { |data| puts data.inspect }
    chain

    parser = ChainReactor::ChainfileParser.new(File.new(chain),get_logger)
    reactor = parser.parse
    assert_equal 1, reactor.reactions_for('192.168.0.1').length
    assert_equal 2, reactor.reactions_for('192.168.0.2').length
  end

  def test_multiple_reactions_are_added_to_reactor_with_alt_syntax
    chain = <<-chain
    react_to(['192.168.0.1','192.168.0.2']) { |data| puts data.inspect }
    chain

    parser = ChainReactor::ChainfileParser.new(File.new(chain),get_logger)
    reactor = parser.parse
    assert_equal 1, reactor.reactions_for('192.168.0.1').length
    assert_equal 1, reactor.reactions_for('192.168.0.2').length
  end

  def test_single_reaction_with_options_is_added_to_reactor
    chain = <<-chain
    react_to('192.168.0.1', parser: :dummy, required_keys: [:hello,:world]) { |data| puts data.inspect }
    chain

    parser = ChainReactor::ChainfileParser.new(File.new(chain),get_logger)
    reactor = parser.parse
    reactions = reactor.reactions_for('192.168.0.1')
    reaction = reactions.first

    assert_equal 1, reactions.length
    assert_equal :dummy, reaction.options[:parser]
    assert_equal [:hello,:world], reaction.options[:required_keys]
  end
end
