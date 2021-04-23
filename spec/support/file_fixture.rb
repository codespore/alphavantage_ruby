module FileFixture
  def file_fixture(filename)
    Pathname.new(__FILE__).join('..','..','fixtures',filename).read
  end
end