require 'test/unit'
require 'rubygems'
require 'open3'
require 'sys/proctable'
require 'client'

# Test case for the options of the chain reactor executable.
class TestChainReactorStart < Test::Unit::TestCase
  include Sys

  def setup
    @test_path = File.dirname(__FILE__) 
    @bin_path = @test_path + '/../bin/chain-reactor'
    @chainfile_path = @test_path + '/chainfile.test'
    @pid_path = @test_path + '/chain-reactor.pid'
  end

  def teardown
    stop_chain_reactor
    $stdout = STDOUT
  end

  def start_chain_reactor(arg_string)
    Open3.popen3("#{@bin_path} start #{@chainfile_path} #{arg_string} --pidfile #{@pid_path}")
  end

  def stop_chain_reactor
    Open3.popen3("#{@bin_path} stop #{@chainfile_path} --pidfile #{@pid_path}")
  end

  def test_start_daemon
    _, stdout, _, thread = start_chain_reactor('')
    output = stdout.read

    assert_match(/Registered 1 reactions/,output)
    assert_match(/Starting daemon, PID file => #{@pid_path}/,output)
    assert_match(/Daemon has started successfully/,output)

    # Thread stopped as it's daemonized
    assert_equal true, thread.stop?

    assert File.file? @pid_path
    pid = File.new(@pid_path).read.to_i
    prc = ProcTable.ps(pid)

    assert_not_nil prc
    assert_match(/chain\-reactor start/,prc.cmdline)
  end

  def test_start_daemon_and_communicate_with_client
    _, stdout, _, _ = start_chain_reactor('')
    output = stdout.read
    assert_match(/Daemon has started successfully/,output)

    assert_nothing_raised ChainReactor::ClientError do
      $stdout = File.new('/dev/null','w')
      client = ChainReactor::Client.new('127.0.0.1',20000)
      client.send({:hello => :world})
    end

  end
end

