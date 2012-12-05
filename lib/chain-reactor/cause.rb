module ChainReactor

  class Cause
    attr_reader :client, :type, :name

    def initialize(client,type,name)
      @client = client
      @type = type
      @name = name
    end
  end
end
