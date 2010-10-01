class File
  # Returns the contents of a file if it exists, or creates it
  # and provides it to a block to write its contents.
  def self.read_or_create(filename, &block) # :yields: file
    File.open(filename, "w", &block) unless File.exist?(filename)
    File.read(filename)
  end
end
