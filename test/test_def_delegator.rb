class MyQueue
  extend Forwardable
  attr_reader :queue
  def initialize
    @queue = []
  end

  def_delegator :@queue, :push, :mypush
end

class RecordCollection
  attr_accessor :records
  extend Forwardable
  def_delegator :@records, :[], :record_number
end

class RecordCollection # re-open RecordCollection class
  def_delegators :@records, :size, :<<, :map
end


assert "simple delegation for queue" do
  q = MyQueue.new
  q.mypush 42
  assert_equal [42], q.queue
  assert_raise(NoMethodError) do
    q.push 23
  end
end

assert "simple delegation for Records 1" do
  r = RecordCollection.new
  r.records = [4, 5, 6]
  assert_equal 4, r.record_number(0)
  assert_equal 6, r.record_number(2)
end

assert "simple delegation for Records 2" do
  r = RecordCollection.new
  r.records = [1, 2, 3]
  assert_equal 1, r.record_number(0)
  assert_equal 3, r.size
  assert_equal [1, 2, 3, 4], r << 4
  assert_equal [2, 4, 6, 8], r.map { |x| x * 2 }
end

assert "object level delegation is not supported yet" do
  my_hash = Hash.new
  my_array = Array.new
  my_hash.extend Forwardable              # prepare object for delegation
  assert_raise(RuntimeError) do
    my_hash.def_delegator my_array, "push"  # add delegation for STDOUT.puts()
  end
end

