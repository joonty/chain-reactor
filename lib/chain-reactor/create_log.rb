module ChainReactor
  require 'log4r'
  include Log4r

  def self.create_logger(level)
    log = Logger.new 'chain-reactor'
    log.level = ChainReactor.const_get(level.upcase)

    outputter = Outputter.stdout
    outputter.formatter = PatternFormatter.new(:pattern => "%l\t%m")
    log.outputters << outputter
    log
  end
end
