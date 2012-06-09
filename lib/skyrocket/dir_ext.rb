class Dir
  def self.glob_files(pattern, flags = nil)
    if block_given?
      Dir.glob(pattern, flags || 0) do |filename|
        if File.file?(filename)
          yield(filename)
        end
      end
    else
      Dir.glob(pattern, flags || 0).select { |f| File.file?(f) }
    end
  end
end
