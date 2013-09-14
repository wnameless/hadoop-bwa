require 'test_helper'
require 'hadoop/bwa/args_parser'

class ArgsParserTest < Test::Unit::TestCase
  include Hadoop::Bwa::ArgsParser
  include Hadoop::Bwa::Errors
  
  def test_parse
    assert_equal ['test.1'], parse_args('index test.1')
    assert_equal ['test.1', 'test.2'], parse_args('mem test.1 test.2')
    assert_equal ['test.1', 'test.2', 'test.3'], parse_args('mem test.1 test.2 test.3')
    assert_equal ['test.1', 'test.2'], parse_args('aln test.1 test.2')
    assert_equal ['test.1', 'test.2'], parse_args('samse test.1 test.2')
    assert_equal ['test.1', 'test.2', 'test.3', 'test.4', 'test.5'], parse_args('sampe test.1 test.2 test.3 test.4 test.5')
    assert_equal ['test.1', 'test.2'], parse_args('bwasw test.1 test.2')
  end
  
  def test_flag
    assert_equal ['test.1'], parse_args('index -a -C sf test.1')
    assert_equal ['test.1', 'test.2'], parse_args('mem -g -C sf test.1 test.2')
    assert_equal ['test.1', 'test.2', 'test.3'], parse_args('mem -g -C sf test.1 test.2 test.3')
    assert_equal ['test.1', 'test.2'], parse_args('aln -g -C sf test.1 test.2')
    assert_equal ['test.1', 'test.2'], parse_args('samse -g -C sf test.1 test.2')
    assert_equal ['test.1', 'test.2', 'test.3', 'test.4', 'test.5'], parse_args('sampe -g -C sf test.1 test.2 test.3 test.4 test.5')
    assert_equal ['test.1', 'test.2'], parse_args('bwasw -g -C sf test.1 test.2')
  end
  
  def test_parse_error_1
    assert_raise InvalidCommandError do
      parse_args('nope')
    end
  end
  
  def test_parse_error_2
    assert_raise RequiredFilesMissingError do
      parse_args('index')
    end
  end
end