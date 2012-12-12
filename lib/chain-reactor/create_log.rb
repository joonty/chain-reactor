module ChainReactor
  require 'log4r'
  include Log4r

  def self.create_logger(level)
    log = self.create_empty_logger(level)

    outputter = Outputter.stdout
    outputter.formatter = PatternFormatter.new(:pattern => "%l\t%m")
    log.outputters << outputter
    log
  end

  def self.create_empty_logger(level)
    log = Logger.new 'chain-reactor'
    log.level = ChainReactor.const_get(level.upcase)
    log
  end
end
