module Enviera
  VERSION = "0.0.3"
  DESCRIPTION = "Enviera is a tool for looking up all Hiera values available based on a given set of puppet facts"

  class RecoverableError < StandardError
  end

  def self.subcommand= command
    @@subcommand = command
  end

  def self.subcommand
    @@subcommand
  end

  def self.verbosity_level= new_verbosity_level
    @@debug_level = new_verbosity_level
  end

  def self.verbosity_level
    @@debug_level ||= 1
    @@debug_level
  end

  def self.subcommands= commands
    @@subcommands = commands
  end

  def self.subcommands
    @@subcommands
  end
end