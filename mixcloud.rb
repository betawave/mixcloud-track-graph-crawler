require 'net/http'
require 'json'

class WebJsonApi
  def apiRequest(url)
    return JSON.parse(Net::HTTP.get(url))
  end
end

class Mixcloud < WebJsonApi
  @@stem = 'http://api.mixcloud.com/'
  @@metadataflag = '?metadata=1'

  def call(path, metadata=false)
    reqUrl = URI.join(@@stem, path)
    reqUrl = URI.join(reqUrl, @@metadataflag) if metadata
    return apiRequest(reqUrl)
  end
end
