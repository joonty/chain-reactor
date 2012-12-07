mode 'template' do

  output :chainfile do
    description 'An output file location for the template'
  end

  def run
    chainfile = params[:chainfile].value
    chainfile.puts <<-eos
# Do something when 127.0.0.1 sends a JSON
react_to('127.0.0.1') do |data|
  puts data.inspect
end

# Use the same block for multiple addresses, and require JSON keys
react_to( ['127.0.0.1','192.168.0.2'], :requires => [:mykey] ) do |data|
  puts data[:mykey]
end
    eos
    puts "Written example chain file to #{chainfile.path}"
  end
end


