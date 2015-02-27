require 'enviera'
require 'enviera/utils'
require 'enviera/options'
require 'enviera/subcommand'
require 'hiera'
require 'json'

module Enviera
  module Subcommands

    class Hierarchy < Subcommand

      def self.options
        [{:name => :string,
          :description => "Source input is a json string provided as an argument",
          :short => 's',
          :type => :string},
         {:name => :file,
          :description => "Source input is a regular json file",
          :short => 'f',
          :type => :string},
         {:name => :stdin,
          :description => "Source input is taken from stdin (json string)",
          :short => :none},
         {:name => :hiera_config,
          :description => "Path to your hiera config yaml file",
          :short => 'c',
          :type => :string,
          :default => '/etc/puppet/hiera.yaml'},
         {:name => :output,
          :description => "What format to output in. [json|yaml|block]",
          :short => 'o',
          :type => :string,
          :default => 'yaml'}
        ]
      end

      def self.description
        "display the hierarchy in use with the given environment"
      end

      def self.validate options
        sources = [:string, :file, :stdin].collect {|x| x if options[x]}.compact
        Trollop::die "You must specify a source (I.E. -s '{}')" if sources.count.zero?
        Trollop::die "You can only specify one of (#{sources.join(', ')})" if sources.count > 1
        options[:source] = sources.first

        options[:input_data] = case options[:source]
        when :stdin
          STDIN.read
        when :string
          options[:string]
        when :file
          File.read options[:file]
        end
        options
      end

      def self.execute
        begin
          environment = JSON.parse(Enviera::Options[:input_data])
        rescue
          raise "Unable to parse input as valid JSON. Please ensure structure is proper."
        end
        hiera_config = Hiera::Config.load(Enviera::Options[:hiera_config])
        hiera= Hiera.new(:config=>hiera_config)
        sources = []
        hiera.config[:backends].each do |backend|
          sources.push("backend: "+backend)
          Hiera::Backend.datasources(environment) { |source|
            # Presently I'm only handling 'yaml' extensions. I hope someday this works for other stuff
            # But I haven't figured out a smart way to do this with the tools available
            # And it's not urgent for me
            sourcefile = Hiera::Backend.datafile(backend,environment,source,"yaml") or next
            sources.push(sourcefile)
          }
        end
        sources = {'hierarchy' => sources}
        case Enviera::Options[:output]
        when "block"
          sources
        when "json"
          sources.to_json
        when "yaml"
          sources.to_yaml
        else
          sources.to_yaml
        end
      end

    end

  end
end