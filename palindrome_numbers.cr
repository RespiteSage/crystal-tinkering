# Originally written by Jabari Zakiya (jzakiya); I've mostly just cleaned it up

class PalNo
  ONE_DIGIT_PALINDROMES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] of UInt64
  TWO_DIGIT_PALINDROMES = [0, 11, 22, 33, 44, 55, 66, 77, 88, 99] of UInt64

  @digit : UInt64
  @dd : UInt64

  def initialize(digit : Int32)
    @digit = digit.to_u64
    @l = 3
    @dd = 11u64 * digit
  end

  def self.fN(n : Int32, &)
    return ONE_DIGIT_PALINDROMES if n == 1
    return TWO_DIGIT_PALINDROMES if n == 2

    Array.each_product(ONE_DIGIT_PALINDROMES, fN(n - 2), reuse: true) do |(outer, inner)|
      yield outer &* 10u64 &** (n - 1) &+ outer &+ 10u64 &* inner
    end
  end

  def self.fN(n : Int32) : Array(UInt64)
    a = [] of UInt64
    fN(n) { |palindrome| a << palindrome }
    return a
  end

  def show(count, keep)
    to_skip = count - keep
    palindrome_count = 0
    palindromes = [] of UInt64
    while palindrome_count < count
      PalNo.fN(@l - 2).each do |palindrome|
        pal = @digit*10u64 &** (@l - 1) + @digit + 10u64 &* palindrome

        if pal % @dd == 0 && (palindrome_count += 1) > to_skip
          palindromes << pal
        end

        if palindrome_count - to_skip == keep
          break
        end
      end
      @l += 1
    end
    print palindromes
    puts
  end
end

start = Time.monotonic

# puts PalNo.fN(3)

(1..9).each { |digit| PalNo.new(digit).show(20, 20) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(100, 15) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(1000, 10) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(100_000, 1) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(1_000_000, 1) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(10_000_000, 1) }; puts "####"

puts (Time.monotonic - start).total_seconds
