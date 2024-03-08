
class SkipNode

  attr_reader :next, :elem

  def initialize(height, elem)
    @next = [nil] * height
    @elem = elem
  end

  def height
    @next.length
  end
end

class SkipNodeList

  attr_accessor :head

  def initialize(max_height, pr = 0.5, seed = nil)
    @max_height = max_height
    @pr = pr
    @head = SkipNode.new(@max_height, 'H')
    @random = seed ?  Random.new(seed) : Random.new
  end

  def insert_points(elem)
    points = [@head] * @max_height
    (points.length - 1).downto(0).each do |i|
      node = @head
      loop do
        break if node.next[i].nil? || node.next[i].elem >= elem
        node = node.next[i]
      end
      points[i] = node
    end

    points
  end

  def insert(elem)

    new_node = SkipNode.new(generate_height, elem)
    inserts = insert_points(elem)

    inserts.each_with_index do |node, idx|
      if idx < new_node.height
        next_node = node.next[idx]
        node.next[idx] = new_node
        new_node.next[idx] = next_node
      end
    end

    new_node
  end

  def find(elem)
    search(@head, elem, @head.height - 1)
  end

  def search(node, elem, height)
    return nil if node.nil?
    return nil if (node.elem != 'H') && node.elem > elem

    return node if node.elem == elem
    height.downto(0).each do |idx|
      found = search(node.next[idx], elem, idx)
      return found unless found.nil?
    end
    nil
  end

  def remove(elem)
    node_to_delete = find(elem)
    return if node_to_delete.nil?

    inserts = insert_points(elem)

    inserts.each_with_index do |node, idx|
      if node.next[idx] == node_to_delete
        node.next[idx] = node_to_delete.next[idx]
      end
    end
    node_to_delete
  end

  def to_s
    rows = []
    bottom_level = []
    @head.next.each_with_index do |node, idx|
      substr = '[H]'
      current_node = node
      num_chars = 0

      loop do
        break if current_node.nil?
        if idx > 0
          bottom_index = bottom_level.index(current_node.elem)
          dash_count = 5 * bottom_index + 1
          dash_count -= num_chars
          num_chars += dash_count + 4

          substr << '-' * dash_count
          substr << ">[#{current_node.elem}]"
        else
          bottom_level << current_node.elem
          substr << "->[#{current_node.elem}]"
        end
        current_node = current_node.next[idx]
      end
      rows << substr
    end
    rows.reverse.join("\n")
  end

  private

  def generate_height
    height = 1
    while @random.random_number < @pr && height < @max_height
      height += 1
    end
    height
  end
end
