module ChainReactor
  require 'reaction'

  class Reactor

    def initialize(logger)
      @address_map = {}
      @log = logger
    end

    # Add a react_to block from the chain file.
    def add(addresses,options,block)
      reaction = Reaction.new(options,block,@log)
      addresses.each { |addr| add_address(addr,reaction) }
    end

    # Add an address with a reaction.
    def add_address(address,reaction)
      @log.debug { "Linking reaction to address #{address}" }

      if @address_map.has_key? address
        @address_map[address] << reaction
      else
        @address_map[address] = [reaction]
      end
    end

    # React to a client by running the associated reactions.
    # 
    # Raises an error if the address is not allowed - use
    # address_allowed? first.
    def react(address,data_string)
      address_allowed?(address) or raise 'Address is not allowed'
      @address_map[address].each do |reaction|
        @log.info { "Executing reaction for address #{address}" }
        begin
          reaction.execute(data_string)
        rescue Parsers::ParseError => e
          @log.error { "Parser error: #{e.message}" }
        rescue Parsers::RequiredKeyError => e
          @log.error { "Client data invalid: #{e.message}" }
        rescue ReactionError => e
          @log.error { 'Exception raised in reaction: '+e.message }
        end
      end
    end

    # Get an array of reactions for a given address
    def reactions_for(address)
      @address_map[address] if address_allowed?(address)
    end

    # Check whether the IP address is allowed.
    #
    # An IP address is allowed if the chain file specifies a "react_to" block
    # with that address.
    def address_allowed?(address)
      @address_map.has_key? address
    end

  end
end
