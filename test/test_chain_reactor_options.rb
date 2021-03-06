require 'test/unit'
require 'rubygems'
require 'open3'

# Test case for the options of the chain reactor executable.
class TestChainReactorOptions < Test::Unit::TestCase

  def exec_with(arg_string)
    bin_path = File.dirname(__FILE__)+'/../bin/chain-reactor'
    Open3.popen3("#{bin_path} #{arg_string}")
  end

  # Thread can be nil, if ruby 1.8 is used
  def assert_exit_status(thread,expected_status)
    unless thread.nil?
      assert_equal expected_status, thread.value.exitstatus
    end
  end

  def test_help_returns_help_in_stdout
    out = exec_with('--help')
    help = out[1].read

    assert_exit_status(out[3],1)
    assert_match(/NAME\s*chain\-reactor/, help)
    assert_match(/SYNOPSIS\s*chain\-reactor \(start|stop|template\) chainfile\.rb/, help)
  end

  def test_no_args_returns_help_in_stdout_and_fails
    out = exec_with('')
    help = out[1].read

    assert_exit_status(out[3],1)
    assert_match(/NAME\s*chain\-reactor/, help)
    assert_match(/SYNOPSIS\s*chain\-reactor \(start|stop|template\) chainfile\.rb/, help)
  end

  def test_invalid_mode_returns_help_and_fails
    out = exec_with('ssaduhdui')
    help = out[1].read

    assert_exit_status(out[3],1)
    assert_match(/NAME\s*chain\-reactor/, help)
    assert_match(/SYNOPSIS\s*chain\-reactor \(start|stop|template\) chainfile\.rb/, help)
  end

  def test_template_returns_chainfile_in_stdout
    out = exec_with('template')
    template = out[1].read

    assert_exit_status(out[3],0)
    assert_match(/react_to\(/, template)
  end

  def test_start_without_chainfile_fails
    out = exec_with('start')
    error = out[2].read

    assert_exit_status(out[3],1)
    assert_match(/chain-reactor: A valid chainfile must be supplied/, error)
  end

  def test_stop_without_chainfile_fails
    out = exec_with('stop')
    error = out[2].read

    assert_exit_status(out[3],1)
    assert_match(/chain-reactor: A valid chainfile must be supplied/, error)
  end
end
