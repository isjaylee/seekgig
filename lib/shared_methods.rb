module SharedMethods
  def archive
    self.update(archived: true)
  end
end