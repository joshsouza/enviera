require 'base64'
require 'yaml'
# require 'enviera/subcommands/unknown_command'

module Enviera

  class Subcommand

    class << self
      attr_accessor :global_options, :options, :helptext
    end

    @@global_options = [
       {:name          => :version,
          :description => "Show version information"},
       {:name          => :verbose,
          :description => "Be more verbose",
          :short       => 'v'},
       {:name          => :trace,
          :description => "Enable trace debug",
          :short       => 't'},
       {:name          => :quiet,
          :description => "Be less verbose",
          :short       => 'q'},
       {:name          => :help,
          :description => "Information on how to use this command",
          :short       => 'h'}
      ]

    def self.load_config_file
      config = {}
      [ "/etc/enviera/config.yaml", "#{ENV['HOME']}/.enviera/config.yaml", "#{ENV['ENVIERA_CONFIG']}" ].each do |config_file|
        begin
          yaml_contents = YAML.load_file(config_file)
          Utils::info "Loaded config from #{config_file}"
          config.merge! yaml_contents
        rescue
          raise StandardError, "Could not open config file \"#{config_file}\" for reading"
        end if config_file and File.file? config_file
      end
      config
    end

    def self.all_options
      options = @@global_options.dup
      options += self.options if self.options
      # merge in defaults from configuration files
      config_file = self.load_config_file
      options.map!{ | opt|
        key_name = "#{opt[:name]}"
        if config_file.has_key? key_name
          opt[:default] = config_file[key_name]
          opt
        else
          opt
        end
      }
      options
    end

    def self.attach_option opt
      self.suboptions += opt
    end

    def self.find commandname = "unknown_command"
      begin
        require "enviera/subcommands/#{commandname.downcase}"
      rescue Exception => e
        require "enviera/subcommands/unknown_command"
        return Enviera::Subcommands::UnknownCommand
      end
      command_module = Module.const_get('Enviera').const_get('Subcommands')
      command_class = Utils.find_closest_class :parent_class => command_module, :class_name => commandname
      command_class || Enviera::Subcommands::UnknownCommand
    end

    def self.parse

      me = self

      options = Trollop::options do

        version "Enviera version " + Enviera::VERSION.to_s
        banner ["enviera #{me.prettyname}: #{me.description}", me.helptext, "Options:"].compact.join("\n\n")

        me.all_options.each do |available_option|

          skeleton = {:description => "",
                      :short => :none}

          skeleton.merge! available_option
          opt skeleton[:name],
              skeleton[:desc] || skeleton[:description],  #legacy plugins
              :short => skeleton[:short],
              :default => skeleton[:default],
              :type => skeleton[:type]

        end

        stop_on Enviera.subcommands

      end

      if options[:verbose]
        Enviera.verbosity_level += 1
      end

      if options[:trace]
        Enviera.verbosity_level += 2
      end

      if options[:quiet]
        Enviera.verbosity_level = 0
      end

      options

    end

    def self.validate args
      args
    end

    def self.description
      "no description"
    end

    def self.helptext
      "Usage: enviera #{self.prettyname} [options]"
    end

    def self.execute
      raise StandardError, "This command is not implemented yet (#{self.to_s.split('::').last})"
    end

    def self.prettyname
      Utils.snakecase self.to_s.split('::').last
    end

    def self.hidden?
      false
    end

  end

end