def fixture_location(file)
  File.join(File.expand_path('../../fixtures/', __FILE__), file)
end

def fixture(file)
  data = File.read(fixture_location(file))
  file.split('.')[-1] == 'json' ? JSON.parse(data) : data
end
