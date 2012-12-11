require 'test/unit'
require 'rubygems'
require 'conf'
require 'test_helpers'

# Test case for the <tt>ChainReaction::Conf</tt> class.
class TestConf < Test::Unit::TestCase
  include ChainReactor::TestHelpers
  def setup
    @conf = ChainReactor::Conf.instance
  end

  def teardown
    @conf.destroy
  end

  def test_address_from_cli_params
    params = {:address => CliParam.new('192.168.0.1')}
    @conf.set_cli_params params
    assert_equal '192.168.0.1', @conf.address
  end

  def test_address_default
    param = CliParam.new('192.168.0.1')
    param.given = false
    params = {:address => param}
    @conf.set_cli_params params
    @conf.address = '127.0.0.1'
    assert_equal '127.0.0.1', @conf.address
  end

  def test_address_from_default_cli_params
    param = CliParam.new('192.168.0.1')
    param.given = false
    params = {:address => param}
    @conf.set_cli_params params
    assert_equal '192.168.0.1', @conf.address
  end

  def test_address_default_without_cli_param
    @conf.address = '127.0.0.1'
    assert_equal '127.0.0.1', @conf.address
  end

  def test_address_raises_error
    assert_raises(ChainReactor::ConfError) { @conf.address }
  end

  def test_port
    params = {:port => CliParam.new(20000)}
    @conf.set_cli_params params
    assert_equal 20000, @conf.port
  end

  def test_multithreaded
    params = {:multithreaded => CliParam.new(true)}
    @conf.set_cli_params params
    assert_equal true, @conf.multithreaded
  end

  def test_multithreaded_alias
    params = {:multithreaded => CliParam.new(true)}
    @conf.set_cli_params params
    assert_equal true, @conf.multithreaded?
  end

  def test_verbosity
    params = {:verbosity => CliParam.new('debug')}
    @conf.set_cli_params params
    assert_equal 'debug', @conf.verbosity
  end

  def test_silent
    params = {:silent => CliParam.new(true)}
    @conf.set_cli_params params
    assert_equal true, @conf.silent
  end

  def test_silent_alias
    params = {:silent => CliParam.new(true)}
    @conf.set_cli_params params
    assert_equal true, @conf.silent?
  end
end
