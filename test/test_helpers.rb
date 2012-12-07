
module ChainReactor
  module TestHelpers
    def get_logger
      logger = Object.new
      def logger.debug
      end
      def logger.info
      end
      def logger.warning
      end
      def logger.error
      end
      def logger.fatal
      end
      logger
    end
  end
end

