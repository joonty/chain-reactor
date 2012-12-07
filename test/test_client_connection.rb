require 'test/unit'
require 'rubygems'
require 'mocha/setup'
require 'client-connection'
require 'test_helpers'

# Test case for the <tt>ChainReactor::ClientConnection</tt> class.
class TestClientConnection < Test::Unit::TestCase
  include ChainReactor::TestHelpers

  # Create a mock TCPSocket object loaded with the data specified.
  def mock_socket(ip,port)
    addr = ["",port,ip.split('.')]
    sock = stub("client socket")
    peername = stub("peer name")
    sock.stubs(:getpeername).returns(peername)
    peername.stubs(:unpack).returns(addr)
    sock
  end

  # Test that the client IP address is readable.
  def test_ip_exists
    ip = "127.0.0.1"
    client = ChainReactor::ClientConnection.new(mock_socket(ip,""),get_logger)
    assert_equal ip, client.ip
  end

  # Test that the port number is readable.
  def test_port_exists
    port = 20000
    client = ChainReactor::ClientConnection.new(mock_socket("",port),get_logger)
    assert_equal port, client.port
  end
  #
  # Test that the say method uses the puts method on the socket.
  def test_say_uses_socket_puts
    my_string = "This is a string"

    # Create mock socket that checks for method calls
    socket = mock_socket("","")
    socket.expects(:puts).once.with(my_string)

    client = ChainReactor::ClientConnection.new(socket,get_logger)
    client.say(my_string)
  end

  # Test that the close method uses the close method on the socket.
  def test_close_uses_socket_close
    # Create mock socket that checks for method calls
    socket = mock_socket("","")
    socket.expects(:close).once

    client = ChainReactor::ClientConnection.new(socket,get_logger)
    client.close
  end

end
