require 'net/http'
require 'json'

class WebJsonApi
  def initialize(stem)
    @stem = stem
  end

  def apiRequest(path)
    url = URI(@stem + path)
    return JSON.parse(Net::HTTP.get(url))
  end
end

class Mixcloud < WebJsonApi
  @@metadataflag = '?metadata=1'

  def initialize
    super('http://api.mixcloud.com/')
  end

  def call(path, metadata=false)
    reqPath = path
    reqPath += @@metadataflag if metadata
    return apiRequest(reqPath)
  end
end
