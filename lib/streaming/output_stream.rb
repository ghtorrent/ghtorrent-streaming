class OutputStream

  def configure(conf)
    raise StandardError('Unimplemented')
  end

  def update_timestamp(timestamp)
    @timestamp = timestamp
  end

  def write(msg)
    raise StandardError('Unimplemented')
  end

end