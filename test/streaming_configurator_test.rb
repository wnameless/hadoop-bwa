require 'test_helper'
require 'hadoop/bwa/streaming_configurator'

class StreamingConfiguratorTest < Test::Unit::TestCase
  HADOOP_HOME = File.join File.dirname(__FILE__), 'hadoop'
  include Hadoop::Bwa::StreamingConfigurator
  
  def test_config_streaming
    hadoop_cmd, fs_default_name, streaming_jar = config_streaming HADOOP_HOME
    assert_equal File.join(HADOOP_HOME, 'bin', 'hadoop'), hadoop_cmd
    assert_equal 'hdfs://127.0.0.1:54310', fs_default_name
    assert_equal File.join(HADOOP_HOME, 'contrib', 'streaming', 'hadoop-streaming-1.1.1.jar'), streaming_jar
  end
end
