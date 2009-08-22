require 'facets/enumerator'
#require 'facets/enumerable/take'

# = Denumerable
#
# Classes which include Enumerable::Filterable will get versions
# of map, select etc. which return a Filter, so that they work
# horizontally without creating intermediate arrays.
#
module Denumerable

  #
  def map
    Denumerator.new do |output|
      each do |*input|
        output.yield yield(*input)
      end
    end
  end
  alias :collect :map

  #
  def select
    Denumerator.new do |output|
      each do |*input|
        output.yield(*input) if yield(*input)
      end
    end
  end
  alias :find_all :select

  #
  def reject
    Denumerator.new do |output|
      each do |*input|
        output.yield(*input) unless yield(*input)
      end
    end
  end

  # Limit to the first n items in the list
  def take(n)
    Denumerator.new do |output|
      count = 0
      each do |*input|
        break if count >= n
        output.yield(*input)
        count += 1
      end
    end
  end

  # Skip the first n items in the list
  def skip(n)
    Denumerator.new do |output|
      count = 0
      each do |*input|
        output.yield(*input) if count >= n
        count += 1
      end
    end
  end

  # TODO: add more methods, e.g. grep, take_while etc.

  # = Denumerator
  #
  # A class like Enumerator, but which has 'lazy' versions of map, select etc.
  #
  class Denumerator < Enumerable::Enumerator
    include Denumerable
  end

end

=begin test.ae

  r = (1..10).defer.select{ |i| i % 2 == 0 }.map{ |i| i + 100 }.to_a
  r.assert == [102,104,106,108,110]

=end
