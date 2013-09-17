require 'active_support/core_ext/hash'
require 'hadoop/bwa/streaming_configurator'
require 'hadoop/bwa/args_parser'
require 'hadoop/bwa/hdfs_uploader'
require 'hadoop/bwa/errors'
require 'uri'

module Hadoop::Bwa
  # Runner is used to run BWA commands on Hadoop Streaming.
  # @author Wei-Ming Wu
  class Runner
    # BWA_PREREQUISITE defines necessary files for BWA commands.
    BWA_PREREQUISITE = { index: [],   mem: [], aln: ['bwt', 'rbwt'],
                         samse: [], sampe: [], bwasw: [] }.with_indifferent_access
    include StreamingConfigurator
    include ArgsParser
    include Errors
    attr_reader :hadoop_home, :bwa, :hadoop_cmd, :fs_default_name, :streaming_jar
    
    # Creates a Runner.
    #
    # @param [Hash] opts the options of this Runner
    # @option [String] :hadoop_home the location of Hadoop home
    # @option [String] :bwa the location of BWA command
    # @return [Runner] a Runner object
    def initialize opts = {}
      opts = opts.with_indifferent_access
      @hadoop_home = opts[:hadoop_home] || ENV['HADOOP_HOME'] ||
        raise(HadoopNotFoundError,
          'Hadoop home not found. ' <<
          'Please set system variable HADOOP_HOME or ' <<
          'passing :hadoop_home => path_to_hadoop_home.')
      @bwa = opts[:bwa] || which('bwa') ||
        raise(BWANotFoundError,
          'BWA not found. ' <<
          'Please install BWA first or passing :bwa => path_to_bwa.')
      @hadoop_cmd, @fs_default_name, @streaming_jar = config_streaming @hadoop_home
      @uploader = HdfsUploader.new @hadoop_cmd
    end
    
    # Runs a BWA command.
    #
    # @param [String] cmd a BWA command
    # @param [Hash] opts the options of method `run`
    # @option [String] :local the folder where local files located
    # @option [String] :hdfs the folder where HDFS files should be found
    def run cmd, opts = {}
      local = opts[:local] || '.'
      hdfs = opts[:hdfs] || "/user/#{`who am i`.split(/\s+/)[0]}"
      files = parse_args cmd
      @uploader.upload_files local, hdfs, files
      streaming cmd, local, hdfs, files
    end
    
    # Creates a Hadoop Streaming statement.
    #
    # @param [String] cmd a BWA command
    # @param [String] hdfs the folder where HDFS files should be found
    # @param [Array] files an Array contains all names of required files
    def streaming_statement cmd, hdfs, files
      "#{@hadoop_cmd} jar #{@streaming_jar} " <<
      "-files #{files.map { |f| "#{URI.join @fs_default_name, hdfs, f}" }.join ','} " <<
      "-input #{URI.join @fs_default_name, hdfs, 'hadoop-bwa-streaming-input.txt'} " <<
      "-output \"#{File.join hdfs, 'hadoop-bwa-' + cmd.split(/\s+/)[0] + ' ' + Time.now.to_s.split(/\s+/).first(2).join(' ')}\" " <<
      "-mapper \"#{@bwa} #{cmd}\" " <<
      "-reducer NONE"
    end
    
    private
    
    def streaming cmd, local, hdfs, files
      case cmd.split(/\s+/)[0]
      when 'index'
        `#{@bwa} #{cmd}`
        exts = %w(amb ann bwt pac rbwt rpac rsa sa)
        @uploader.upload_files local, hdfs, exts.map { |ext| "#{files[0]}.#{ext}" }
      when 'mem'
        raise NotSupportedError, 'mem not supported yet.'
      when 'aln'
        cmd = files.first
        @uploader.upload_files local, hdfs, files + BWA_PREREQUISITE[cmd].map { |ext| "#{cmd}.#{ext}" }
        system "#{streaming_statement cmd, hdfs, files}"
      when 'samse'
        raise NotSupportedError, 'aln not supported yet.'
      when 'sampe'
        raise NotSupportedError, 'sampe not supported yet.'
      when 'bwasw'
        raise NotSupportedError, 'bwasw not supported yet.'
      else
        raise InvalidCommandError, "Invalid command: #{cmd.split(/\s+/)[0]}."
      end
    end
    
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
