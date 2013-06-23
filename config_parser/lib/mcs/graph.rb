module VersatileDiamond

  class Graph
    extend Forwardable

    attr_reader :original_links

    def initialize(links)
      @edges = Hash[links.map { |key, list| [key, list.dup] }]
      @original_links = links
    end

    def_delegator :@edges, :size

    def each_vertex(&block)
      block_given? ? @edges.keys.each(&block) : @edges.keys.each
    end

    def edge(v, w)
      @edges[v] && (edge = @edges[v].find { |vertex, _| vertex == w }) && edge.last
    end

    def lattices
      each_vertex.map { |atom| atom.lattice }.uniq
    end

    def change_lattice!(atom, lattice)
      new_atom = atom.dup
      new_atom.lattice = lattice
# puts "changing lattice for #{atom.to_s} to #{new_atom.to_s}"
      exchange_atoms!(atom, new_atom)
    end

    def changed_vertex(new_atom)
      @changed_vertices[new_atom]
    end

    def select_vertices(vertices)
      @edges.select { |atom, _| vertices.include?(atom) }.keys
    end

    def remaining_vertices(vertices)
      select_vertices(@edges.keys - vertices.to_a)
    end

    def boundary_vertices(vertices)
      result = Set.new
      each_unique_edge do |atom, another_atom, link|
        next if vertices.include?(atom) && vertices.include?(another_atom)
        result << atom if vertices.include?(another_atom)
        result << another_atom if vertices.include?(atom)
      end
      result.to_a
    end

    def remove_edges!(vertices)
      @edges.each do |atom, links|
        links.reject! { |another_atom, _| vertices.include?(atom) && vertices.include?(another_atom) }
      end
    end

    def remove_vertices!(vertices)
      @edges.reject! { |atom, _| vertices.include?(atom) }
      @edges.each do |_, links|
        links.reject! { |atom, _| vertices.include?(atom) }
      end
    end

    def remote_disconnected_vertices!
      @edges.reject! { |_, links| links.empty? }
    end

    def atom_alias
      @atom_alias ||= @edges.each_with_index.with_object({}) { |((atom, _), i), hash| hash[atom] = "#{atom}_#{i}" }
    end

    def to_s
      strs = @edges.map do |atom, links|
        str = links.map { |another_atom, link| "#{link}#{atom_alias[another_atom]}" }.join(', ')
        "  #{atom_alias[atom]} => [#{str}]"
      end
      %Q|{\n#{strs.join(",\n")}\n}|
    end

  private

    def exchange_atoms!(from, to)
      links = @edges.delete(from)
      links.each do |atom, _|
        @edges[atom].map! do |a, link|
          [(a == from ? to : a), link]
        end
      end
      @edges[to] = links

      @changed_vertices ||= {}
      @changed_vertices[to] = from
    end

    def each_edge(&block)
      @edges.each do |atom, list|
        list.each { |another_atom, link| block[atom, another_atom, link] }
      end
    end

    def each_unique_edge(&block)
      cache = EdgeCache.new
      each_edge do |atom, another_atom, link|
        next if cache.has?(atom, another_atom)
        block[atom, another_atom, link]
        cache.add(atom, another_atom)
      end
    end
  end

end
