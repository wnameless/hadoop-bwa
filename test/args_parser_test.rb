require 'test_helper'
require 'hadoop/bwa/args_parser'

class ArgsParserTest < Test::Unit::TestCase
  include Hadoop::Bwa::ArgsParser
  include Hadoop::Bwa::Errors
  
  def test_parse
    assert_equal ['test.1'], parse('index test.1')
    assert_equal ['test.1', 'test.2'], parse('mem test.1 test.2')
    assert_equal ['test.1', 'test.2', 'test.3'], parse('mem test.1 test.2 test.3')
    assert_equal ['test.1', 'test.2'], parse('aln test.1 test.2')
    assert_equal ['test.1', 'test.2'], parse('samse test.1 test.2')
    assert_equal ['test.1', 'test.2', 'test.3', 'test.4', 'test.5'], parse('sampe test.1 test.2 test.3 test.4 test.5')
    assert_equal ['test.1', 'test.2'], parse('bwasw test.1 test.2')
  end
  
  def test_flag
    assert_equal ['test.1'], parse('index -a -C sf test.1')
    assert_equal ['test.1', 'test.2'], parse('mem -g -C sf test.1 test.2')
    assert_equal ['test.1', 'test.2', 'test.3'], parse('mem -g -C sf test.1 test.2 test.3')
    assert_equal ['test.1', 'test.2'], parse('aln -g -C sf test.1 test.2')
    assert_equal ['test.1', 'test.2'], parse('samse -g -C sf test.1 test.2')
    assert_equal ['test.1', 'test.2', 'test.3', 'test.4', 'test.5'], parse('sampe -g -C sf test.1 test.2 test.3 test.4 test.5')
    assert_equal ['test.1', 'test.2'], parse('bwasw -g -C sf test.1 test.2')
  end
  
  def test_parse_error_1
    assert_raise InvalidCommandError do
      parse('nope')
    end
  end
  
  def test_parse_error_2
    assert_raise RequiredFilesMissingError do
      parse('index')
    end
  end
end