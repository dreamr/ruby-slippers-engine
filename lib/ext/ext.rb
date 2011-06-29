require 'iconv'

class Object
  def meta_def name, &blk
    (class << self; self; end).instance_eval do
      define_method(name, &blk)
    end
  end
end

class String
  def slugize(slug = '-')
    slugged = Iconv.iconv('ascii//TRANSLIT//IGNORE', 'utf-8', self).to_s
    slugged.gsub!(/&/, 'and')
    slugged.gsub!(/[^\w_\-#{Regexp.escape(slug)}]+/i, slug)
    slugged.gsub!(/#{slug}{2,}/i, slug)
    slugged.gsub!(/^#{slug}|#{slug}$/i, '')
    url_encode(slugged.downcase)
  end

  def url_encode(word)
    URI.escape(word, /[^\w_+-]/i)
  end

  def humanize
    self.capitalize.gsub(/[-_]+/, ' ')
  end
end

class Fixnum
  def ordinal
    # 1 => 1st
    # 2 => 2nd
    # 3 => 3rd
    # ...
    case self % 100
      when 11..13; "#{self}th"
    else
      case self % 10
        when 1; "#{self}st"
        when 2; "#{self}nd"
        when 3; "#{self}rd"
        else    "#{self}th"
      end
    end
  end
end

class Object
  def blank?
    self.nil? || self == ""
  end
end

class Date
  # This check is for people running RubySlippers::Enginewith ActiveSupport, avoid a collision
  unless respond_to? :iso8601
    # Return the date as a String formatted according to ISO 8601.
    def iso8601
      ::Time.utc(year, month, day, 0, 0, 0, 0).iso8601
    end
  end
end

module Kernel
  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null')
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
  end
end

require 'enumerator'

class Array
  # Splits or iterates over the array in groups of size +number+,
  # padding any remaining slots with +fill_with+ unless it is +false+.
  #
  #   %w(1 2 3 4 5 6 7).in_groups_of(3) {|group| p group}
  #   ["1", "2", "3"]
  #   ["4", "5", "6"]
  #   ["7", nil, nil]
  #
  #   %w(1 2 3).in_groups_of(2, '&nbsp;') {|group| p group}
  #   ["1", "2"]
  #   ["3", "&nbsp;"]
  #
  #   %w(1 2 3).in_groups_of(2, false) {|group| p group}
  #   ["1", "2"]
  #   ["3"]
  def in_groups_of(number, fill_with = nil)
    if fill_with == false
      collection = self
    else
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - size % number) % number
      collection = dup.concat([fill_with] * padding)
    end

    if block_given?
      collection.each_slice(number) { |slice| yield(slice) }
    else
      groups = []
      collection.each_slice(number) { |group| groups << group }
      groups
    end
  end

  # Splits or iterates over the array in +number+ of groups, padding any
  # remaining slots with +fill_with+ unless it is +false+.
  #
  #   %w(1 2 3 4 5 6 7 8 9 10).in_groups(3) {|group| p group}
  #   ["1", "2", "3", "4"]
  #   ["5", "6", "7", nil]
  #   ["8", "9", "10", nil]
  #
  #   %w(1 2 3 4 5 6 7).in_groups(3, '&nbsp;') {|group| p group}
  #   ["1", "2", "3"]
  #   ["4", "5", "&nbsp;"]
  #   ["6", "7", "&nbsp;"]
  #
  #   %w(1 2 3 4 5 6 7).in_groups(3, false) {|group| p group}
  #   ["1", "2", "3"]
  #   ["4", "5"]
  #   ["6", "7"]
  def in_groups(number, fill_with = nil)
    # size / number gives minor group size;
    # size % number gives how many objects need extra accommodation;
    # each group hold either division or division + 1 items.
    division = size / number
    modulo = size % number

    # create a new array avoiding dup
    groups = []
    start = 0

    number.times do |index|
      length = division + (modulo > 0 && modulo > index ? 1 : 0)
      padding = fill_with != false &&
        modulo > 0 && length == division ? 1 : 0
      groups << slice(start, length).concat([fill_with] * padding)
      start += length
    end

    if block_given?
      groups.each { |g| yield(g) }
    else
      groups
    end
  end

  # Divides the array into one or more subarrays based on a delimiting +value+
  # or the result of an optional block.
  #
  #   [1, 2, 3, 4, 5].split(3)                # => [[1, 2], [4, 5]]
  #   (1..10).to_a.split { |i| i % 3 == 0 }   # => [[1, 2], [4, 5], [7, 8], [10]]
  def split(value = nil)
    using_block = block_given?

    inject([[]]) do |results, element|
      if (using_block && yield(element)) || (value == element)
        results << []
      else
        results.last << element
      end

      results
    end
  end
end
