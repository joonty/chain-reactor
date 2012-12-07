require 'test/unit'
require 'rubygems'
require 'reactor'
require 'test_helpers'
require 'dummy_parser'


# Test case for the <tt>ChainReactor::Reaction</tt> class.
class TestReaction < Test::Unit::TestCase
  include ChainReactor::TestHelpers
  
  def test_block_is_executed
    block = Proc.new { |d| raise 'Block has been called' }
    reaction = ChainReactor::Reaction.new({:parser => :dummy}, block, get_logger)

    assert_raise ChainReactor::ReactionError, 'Block has been called' do
      reaction.execute('')
    end
  end

  def test_execute_sets_previous_result
    block = Proc.new { |d| 'Block has been called' }
    reaction = ChainReactor::Reaction.new({:parser => :dummy}, block, get_logger)
    reaction.execute('')

    assert_equal 'Block has been called', reaction.previous_result
  end
  
  def test_execute_sets_previous_data
    
    block = Proc.new { |d| 'Block has been called' }
    reaction = ChainReactor::Reaction.new({:parser => :json}, block, get_logger)
    data_string = '{"hello" : "world"}'
    data = {:hello => 'world'}
    reaction.execute(data_string)

    assert_equal data, reaction.previous_data
  end
end
