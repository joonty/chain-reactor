module ChainReactor

  require 'log4r'
  include Log4r

  # Creates a logger object that prints to STDOUT.
  def self.create_logger(level)
    log = self.create_empty_logger(level)

    outputter = Outputter.stdout
    outputter.formatter = PatternFormatter.new(:pattern => "%l\t%m")
    log.outputters << outputter
    log
  end

  # Creates a logger object with no outputter.
  def self.create_empty_logger(level)
    log = Logger.new 'chain-reactor'
    log.level = ChainReactor.const_get(level.upcase)
    log
  end
end
