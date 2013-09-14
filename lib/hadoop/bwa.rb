require 'hadoop/bwa/version'
require 'hadoop/bwa/streaming_configurator'
require 'hadoop/bwa/errors'
require 'active_support/core_ext/hash'

module Hadoop
  module Bwa
    def self.new opts = {}
      Instance.new opts
    end
    
    class Instance
      include StreamingConfigurator
      include Errors
      attr_reader :hadoop_home, :bwa
      
      def initialize opts = {}
        opts = opts.with_indifferent_access
        @hadoop_home = opts[:hadoop_home] || ENV['HADOOP_HOME'] ||
          raise(HadoopNotFoundError, 'Hadoop home not found. ' <<
            'Please set system variable HADOOP_HOME or ' <<
            'passing :hadoop_home => path_to_hadoop_home.')
        @bwa = opts[:bwa] || which('bwa') ||
          raise(BWANotFoundError, 'BWA not found. ' <<
            'Please install BWA first or passing :bwa => path_to_bwa.')
        @hadoop_cmd, @fs_default_name, @streaming_jar = config_streaming @hadoop_home
      end
      
      private
      
      def which cmd
        exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
          exts.each do |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable? exe
          end
        end
        nil
      end
    end
  end
end