require 'enviera/subcommand'

module Enviera
  module Subcommands

    class UnknownCommand < Enviera::Subcommand

      class << self
        attr_accessor :original_command
      end

      @@original_command = "unknown"

      def self.options
        []
      end

      def self.description
        "Unknown command (#{@@original_command})"
      end

      def self.execute
        subcommands = Enviera.subcommands
        puts <<-EOS
Unknown subcommand#{ ": " + Enviera.subcommand if Enviera.subcommand }
Usage: enviera <subcommand>
Please use one of the following subcommands or help for more help:
  #{Enviera.subcommands.sort.collect {|command|
  command_class = Subcommands.const_get(Utils.camelcase command)
  command unless command_class.hidden?
}.compact.join(", ")}
EOS
      end

      def self.hidden?
        true
      end

    end

  end
end