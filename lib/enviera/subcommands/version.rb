require 'enviera/subcommand'
require 'enviera'

module Enviera
  module Subcommands

    class Version < Subcommand

      def self.options
        []
      end

      def self.description
        "show version information"
      end

      def self.execute
        Enviera::Utils.info "enviera (core): #{Enviera::VERSION}"

        nil

      end

    end

  end
end