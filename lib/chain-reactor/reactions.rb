module ChainReactor
  module Reactions

    class ReactionError < StandardError
    end

    class ReactionList
      @@reactions = {}
      def self.add(name,block)
        @@reactions[name.to_s] = block
      end

      def self.get(name)
        name_s = name.to_s
        if @@reactions.has_key?(name_s)
          @@reactions[name_s]
        else
          raise ReactionError, "Reaction \"#{name}\" does not exist"
        end
      end

      def self.exec(name,cause)
        block = self.get(name)
        block.call(cause)
      end

    end

    def self.reaction(name,&block)
      ReactionList.add(name,block)
    end
  end
end
