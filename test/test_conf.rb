require 'test/unit'
require 'rubygems'
require 'conf'
require 'test_helpers'

# Test case for the <tt>ChainReaction::Conf</tt> class.
class TestConf < Test::Unit::TestCase
  include ChainReactor::TestHelpers
  def get_conf(cli_params)
    ChainReactor::Conf.new(cli_params)
  end

  def test_address_from_cli_params
    params = {:address => CliParam.new('192.168.0.1')}
    conf = get_conf params
    assert_equal '192.168.0.1', conf.address
  end

  def test_address_default
    param = CliParam.new('192.168.0.1')
    param.given = false
    params = {:address => param}
    conf = get_conf params
    conf.address = '127.0.0.1'
    assert_equal '127.0.0.1', conf.address
  end

  def test_address_from_default_cli_params
    param = CliParam.new('192.168.0.1')
    param.given = false
    params = {:address => param}
    conf = get_conf params
    assert_equal '192.168.0.1', conf.address
  end

  def test_address_default_without_cli_param
    conf = ChainReactor::Conf.new({})
    conf.address = '127.0.0.1'
    assert_equal '127.0.0.1', conf.address
  end

  def test_address_raises_error
    conf = ChainReactor::Conf.new({})
    assert_raises(ChainReactor::ConfError) { conf.address }
  end

  def test_port
    params = {:port => CliParam.new(20000)}
    conf = get_conf params
    assert_equal 20000, conf.port
  end

  def test_pid_file
    pid_file = '/path/to/pid.file'
    params = {:pidfile => CliParam.new(pid_file)}
    conf = get_conf params
    assert_equal pid_file, conf.pid_file
  end

  def test_log_file
    log_file = '/path/to/log.file'
    params = {:logfile => CliParam.new(log_file)}
    conf = get_conf params
    assert_equal log_file, conf.log_file
  end

  def test_multithreaded
    params = {:multithreaded => CliParam.new(true)}
    conf = get_conf params
    assert_equal true, conf.multithreaded
  end

  def test_multithreaded_alias
    params = {:multithreaded => CliParam.new(true)}
    conf = get_conf params
    assert_equal true, conf.multithreaded?
  end

  def test_verbosity
    params = {:verbosity => CliParam.new('debug')}
    conf = get_conf params
    assert_equal 'debug', conf.verbosity
  end

  def test_silent
    params = {:silent => CliParam.new(true)}
    conf = get_conf params
    assert_equal true, conf.silent
  end

  def test_silent_alias
    params = {:silent => CliParam.new(true)}
    conf = get_conf params
    assert_equal true, conf.silent?
  end

  def test_on_top
    params = {:ontop => CliParam.new(true)}
    conf = get_conf params
    assert_equal true, conf.on_top
  end

  def test_on_top_alias
    params = {:ontop => CliParam.new(true)}
    conf = get_conf params
    assert_equal true, conf.on_top?
  end
end
