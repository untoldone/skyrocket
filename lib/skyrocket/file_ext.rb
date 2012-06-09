class File
  def self.write_file(file, string)
    File.open(file, 'w') { |f| f.write(string) }
  end
end
