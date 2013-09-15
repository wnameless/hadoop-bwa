module Hadoop::Bwa
  module Errors
    class HadoopNotFoundError < Exception ; end
    class BWANotFoundError < Exception ; end
    class FSDefaultNameNotFoundError < Exception ; end
    class HadoopCommandNotFoundError < Exception ; end
    class StreamingJarNotFoundError < Exception ; end
    class InvalidCommandError < Exception ; end
    class RequiredFilesMissingError < Exception ; end
    class HdfsFileUploadingError < Exception ; end
  end
end