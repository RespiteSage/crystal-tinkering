module Foo
end

module FooToo
end

module Bar
  extend Foo
  include FooToo

  def self.print_parents
    puts {{ @type.ancestors.select(&.module?).stringify }}
  end

  def self.print_class_parents
    puts {{ @type.class.ancestors.select(&.module?).stringify }}
  end
end

Bar.print_parents       # => [FooToo]
Bar.print_class_parents # => [Foo]
