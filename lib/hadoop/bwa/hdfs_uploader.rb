require 'hadoop/bwa/errors'

module Hadoop::Bwa
  class HdfsUploader
    include Errors
    
    def initialize hadoop_cmd
      @hadoop_cmd = hadoop_cmd
    end
    
    def upload_files local, hdfs, files
      local_files = Dir[File.join local, '*'].map { |f| File.basename f }
      remote_files = ls_remote(hdfs).map { |f| File.basename f }
      unuploaded_files = files - remote_files
      if (unuploaded_files - local_files).any?
        raise HdfsFileUploadingError, "Files: #{unuploaded_files - local_files} " <<
          "can't be found on either local or hdfs."
      end
      upload_hdfs unuploaded_files.map { |f| File.join local, f }
    end
    
    private
    
    def upload_hdfs hdfs, files
      files.each do |f|
        system "#{@hadoop_cmd} fs -put #{f} #{File.join hdfs, File.basename(f)}"
      end
    end
    
    def ls_remote hdfs
      result = `#{@hadoop_cmd} fs -ls #{hdfs}`
      result.drop(1).map { |line| line.split(/ /).slice_before(/^\//).to_a.last.join(' ') }
    end
  end  
end
