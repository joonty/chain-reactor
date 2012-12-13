
module ChainReactor
  module TestHelpers
    class Logger
      def debug
      end
      def info
      end
      def warning
      end
      def error
      end
      def fatal
      end
    end

    class Params
      def initialize(hash_data)
        @hash = hash_data
      end

      def method_missing(name, *args, &block)
        @hash.send(name, *args, &block)
      end

      def fetch(key,&block)
        begin
          @hash.fetch(key,&block)
        rescue KeyError => e
          raise ::Main::Parameter::NoneSuch, key
        end
      end

    end

    class CliParam
      def initialize(value)
        @value = value
        @given = true
      end

      def value
        @value
      end

      def given=(given)
        @given = given
      end

      def given?
        @given
      end
    end

    class File
      def initialize(string)
        @string = string
      end

      def read
        @string
      end
    end

    def get_logger
      Logger.new
    end

  end
end

