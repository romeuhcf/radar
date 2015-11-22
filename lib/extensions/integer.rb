class Integer
  def to_column
    name = 'A'
    (self - 1).times { name.succ! }
    name
  end
end
