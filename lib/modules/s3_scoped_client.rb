class S3ScopedClient

  def initialize(s3_object, bucket)
    @s3 = s3_object
    @bucket = s3_object.buckets[bucket]
  end

  # This nasty little hack is to get around the fact that AWS::S3 explodes if you try to use
  # the Tree processing with directories containing a large number of subdirectories
  #
  def leaves(prefix)
    leaves = []
    marker = nil
    begin
      resp = @s3.client.list_objects(:bucket_name => @bucket.name, :prefix => prefix, :delimiter => '/', :max_keys => 1000, :marker => marker)
      leaves += resp[:common_prefixes].map {|hash| hash[:prefix]}
      marker = resp[:next_marker]
    end until marker.nil?
    leaves
  end

  # This one is to get around the fact that AWS::S3 doesn't suppor wildcards in path prefixes
  #
  def wildcard_leaves(prefix)
    parts = prefix.split("*")
    parts[1..-1].reduce([parts.first]) do |paths, chunk|
      paths.map do |prefix|
        leaves(prefix).map {|path| [path.sub(/\/$/, ''), chunk].join}
      end.flatten
    end.map do |path|
      leaves(path)
    end.flatten
  end

  def delete(key)
    @bucket.objects[key].delete
  end

  def get(key)
    @bucket.objects[key].read
  rescue AWS::S3::Errors::NoSuchKey
    nil
  end

  def head(key)
    @bucket.objects[key].head
  end

  def keys(args={})
    prefix = args[:prefix] || args['prefix']
    if prefix
      @bucket.objects.with_prefix(prefix).map(&:key)
    else
      @bucket.objects.map(&:key)
    end
  end

  # Yields individual lines from an s3 object, grabbing no more than 5MB at
  # once.
  #
  # Useful if you need to process all the lines in a file and don't want to
  # blow up a ruby processes memory usage.
  READ_SIZE = 5 * 1024 # 5.megabytes
  def stream_lines(key)
    s3obj = @bucket.objects[key]
    current_pos = 0

    length = s3obj.content_length

    while current_pos < length
      range_end  = current_pos + READ_SIZE
      range_end  = length if range_end > length

      data_piece        = s3obj.read(:range => current_pos..range_end)
      last_line_ends_at = data_piece.rindex("\n")

      StringIO.new(data_piece[0..last_line_ends_at]).each_line { |l| yield l.chomp }

      current_pos += (last_line_ends_at + 1)
    end
  end

  def put(key, value)
    @bucket.objects[key].write(value)
  end

  def put_file(key, file)
    @bucket.objects[key].write(file, :content_length => file.size)
  end


  def object(key)
    @bucket.objects[key]
  rescue AWS::S3::Errors::NoSuchKey
    nil
  end

  def key_exists?(key)
    key = object(key)
    !key.nil? && key.exists?
  end
  alias :exists? :key_exists?

  def objects(options={})
    if options[:prefix]
      return @bucket.objects.with_prefix(options[:prefix])
    else
      return @bucket.objects
    end
  end

  def prefix_size(prefix)
    sum = 0
    each_raw_object(prefix) do |raw_obj|
      sum += raw_obj[:size].to_i
    end
    sum
  end

  # AWS's S3 does not support caching of s3
  # object attributes when listing objects:
  #
  # https://github.com/aws/aws-sdk-ruby/pull/84
  #
  # As a result we have this work around which
  # allows us access to the raw objects.
  def each_raw_object(prefix=nil)
    marker = nil
    begin
      resp = @s3.client.list_objects(:bucket_name => @bucket.name,
                                     :prefix => prefix,
                                     :delimiter => '/',
                                     :max_keys => 1000,
                                     :marker => marker)
      resp[:contents].each do |raw_obj|
        yield raw_obj
      end
      marker = resp[:next_marker]
    end until marker.nil?
  end
end

