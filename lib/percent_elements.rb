class Array
  def percent_elements(percent)
    take((size * percent / 100.0).ceil)
  end
end
