require 'enviera/subcommand'
require 'enviera'

module Enviera
  module Subcommands

    class Help < Subcommand

      def self.options
        []
      end

      def self.description
        "this page"
      end

      def self.execute

        puts <<-EOS
Welcome to enviera #{Enviera::VERSION}
Usage:
enviera subcommand [global-opts] [subcommand-opts]
Available subcommands:
#{Enviera.subcommands.collect {|command|
  command_class = Subcommands.const_get(Utils.camelcase command)
  sprintf "%15s: %-65s", command.downcase, command_class.description unless command_class.hidden?
}.compact.join("\n")}
For more help on an individual command, use --help on that command
EOS
      end

      def self.hidden?
        true
      end

    end

  end
end