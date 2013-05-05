class Bond
  def self.[](face: nil, dir: nil)
    key = face.to_s
    key << "_#{dir}" if dir
    @consts ||= {}
    @consts[key] ||= new(face, dir)
  end

  def initialize(face, dir)
    @face, @dir = face, dir
  end

  def to_s
    '-'
  end
end