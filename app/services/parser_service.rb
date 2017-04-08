class ParserService

  def upload_fields_from(file)
    file.read.each_line do |line|
      clean_string(line)
    end
  end

  private

  def clean_string(str)
    str.tr("\n", ' ').tr('.', ' ').tr(',',' ')
  end
end
