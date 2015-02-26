require 'enviera'
require 'enviera/utils'
require 'enviera/options'
require 'enviera/subcommand'
require 'trollop'

module Enviera
  class CLI

    def self.parse

      Utils.require_dir 'enviera/subcommands'
      Enviera.subcommands = Utils.find_all_subclasses_of({ :parent_class => Enviera::Subcommands }).collect {|classname| Utils.snakecase classname}

      Enviera.subcommand = ARGV.shift
      subcommand = case Enviera.subcommand
      when nil
        ARGV.delete_if {true}
        "unknown_command"
      when /^\-/
        ARGV.delete_if {true}
        "help"
      else
        Enviera.subcommand
      end

      command_class = Subcommand.find subcommand

      options = command_class.parse
      options[:executor] = command_class

      options = command_class.validate options
      Enviera::Options.set options
      Enviera::Options.trace

    end

    def self.execute

      executor = Enviera::Options[:executor]
      begin
        result = executor.execute
        puts result unless result.nil?
      rescue Exception => e
        Utils.warn e.message
        Utils.debug e.backtrace.join("\n")
      end

    end

  end

end
