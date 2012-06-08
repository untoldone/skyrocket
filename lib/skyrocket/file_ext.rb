class File
  def write_file(file, string)
    File.open(file, 'w') { |f| f.write(string) }
  end
end
