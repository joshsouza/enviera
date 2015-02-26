
module Enviera
  class Utils

    def self.read_password
      ask("Enter password: ") {|q| q.echo = "*" }
    end

    def self.confirm? message
      result = ask("#{message} (y/N): ")
      if result.downcase == "y" or result.downcase == "yes"
        true
      else
        false
      end
    end

    def self.camelcase string
      return string if string !~ /_/ && string =~ /[A-Z]+.*/
      string.split('_').map{|e| e.capitalize}.join
    end

    def self.snakecase string
      return string if string !~ /[A-Z]/
      string.split(/(?=[A-Z])/).collect {|x| x.downcase}.join("_")
    end

    def self.find_closest_class args
      parent_class = args[ :parent_class ]
      class_name = args[ :class_name ]
      constants = parent_class.constants
      candidates = []
      constants.each do | candidate |
        candidates << candidate.to_s if candidate.to_s.downcase == class_name.downcase
      end
      if candidates.count > 0
        parent_class.const_get candidates.first
      else
        nil
      end
    end

    def self.require_dir classdir
      num_class_hierarchy_levels = self.to_s.split("::").count - 1
      root_folder = File.dirname(__FILE__) + "/" + Array.new(num_class_hierarchy_levels).fill("..").join("/")
      class_folder = root_folder + "/" + classdir
      Dir[File.expand_path("#{class_folder}/*.rb")].uniq.each do |file|
        self.trace "Requiring file: #{file}"
        require file
      end
    end

    def self.find_all_subclasses_of args
      parent_class = args[ :parent_class ]
      constants = parent_class.constants
      candidates = []
      constants.each do | candidate |
        candidates << candidate.to_s.split('::').last if parent_class.const_get(candidate).class.to_s == "Class"
      end
      candidates
    end

    def self.structure_message messageinfo
      message = {:from => "enviera-core"}
      case messageinfo.class.to_s
      when 'Hash'
        message.merge!(messageinfo)
      else
        message.merge!({:msg => messageinfo.to_s})
      end
      message[:prefix] = "[#{message[:from]}]"
      message[:spacer] = " #{' ' * message[:from].length} "
      formatted_output = message[:msg].split("\n").each_with_index.map do |line, index|
        if index == 0
          "#{message[:prefix]} #{line}"
        else
          "#{message[:spacer]} #{line}"
        end
      end
      formatted_output.join "\n"
    end

    def self.warn messageinfo
      self.print_message({ :message => self.structure_message( messageinfo ), :enviera_loglevel => :warn, :cli_color => :red })
    end

    def self.info messageinfo
      self.print_message({ :message => self.structure_message( messageinfo ), :enviera_loglevel => :debug, :cli_color => :white, :threshold => 0 })
    end

    def self.debug messageinfo
      self.print_message({ :message => self.structure_message( messageinfo ), :enviera_loglevel => :debug, :cli_color => :green, :threshold => 1 })
    end

    def self.trace messageinfo
      self.print_message({ :message => self.structure_message( messageinfo ), :enviera_loglevel => :debug, :cli_color => :blue, :threshold => 2 })
    end

    def self.print_message( args )
      message        = args[:message] ||= ""
      enviera_loglevel = args[:enviera_loglevel] ||= :debug
      cli_color      = args[:cli_color] ||= :blue
      threshold      = args[:threshold]

      STDERR.puts self.colorize( message, cli_color ) if threshold.nil? or Enviera.verbosity_level > threshold
    end

    def self.colorize message, color
      suffix = "\e[0m"
      prefix = case color
      when :red
        "\e[31m"
      when :green
        "\e[32m"
      when :blue
        "\e[34m"
      else #:white
        "\e[0m"
      end
      "#{prefix}#{message}#{suffix}"
    end

  end
end