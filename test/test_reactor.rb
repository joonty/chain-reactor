require 'test/unit'
require 'rubygems'
require 'reactor'
require 'helpers'
require 'dummy_parser'

# Test case for the <tt>ChainReaction::Reaction</tt> class.
class TestReactor < Test::Unit::TestCase
  include ChainReactor::TestHelpers
  
  def test_address_not_allowed_by_default
    reactor = ChainReactor::Reactor.new get_logger
    assert_equal false, reactor.address_allowed?('192.168.0.1')
  end
  
  def test_adding_reaction_makes_address_allowable
    reactor = ChainReactor::Reactor.new get_logger
    reactor.add(['127.0.0.1'],{parser: :dummy},Proc.new {})
    assert reactor.address_allowed? '127.0.0.1'
  end

  def test_react_raises_error
    reactor = ChainReactor::Reactor.new get_logger
    assert_raises RuntimeError, 'Address is not allowed' do
      reactor.react('127.0.0.1',{parser: :dummy})
    end
  end

  def test_react_calls_block
    reactor = ChainReactor::Reactor.new get_logger
    block = Proc.new { |d| 'block has been called' }
    reactor.add(['127.0.0.1'],{parser: :dummy},block)
    reactions = reactor.reactions_for('127.0.0.1')
    reactor.react('127.0.0.1','This is a string')
    assert_equal 'block has been called', reactions[0].previous_result
  end

  def test_react_calls_multiple_blocks
    reactor = ChainReactor::Reactor.new get_logger

    block1 = Proc.new { |d| 'block1' }
    block2 = Proc.new { |d| 'block2' }

    reactor.add(['127.0.0.1'],{parser: :dummy},block1)
    reactor.add(['127.0.0.1'],{parser: :dummy},block2)

    reactor.react('127.0.0.1','This is a string')

    reactions = reactor.reactions_for('127.0.0.1')
    assert_equal 'block1', reactions[0].previous_result
    assert_equal 'block2', reactions[1].previous_result
  end

  def test_react_catches_exceptions
    reactor = ChainReactor::Reactor.new get_logger
    block = Proc.new { |d| raise 'Block has been called' }
    reactor.add(['127.0.0.1'],{parser: :dummy},block)
    reactor.reactions_for('127.0.0.1')
    assert_nothing_raised do
      reactor.react('127.0.0.1','This is a string')
    end
  end
end
