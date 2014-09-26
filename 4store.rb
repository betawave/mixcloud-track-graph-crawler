require 'cgi'
require 'net/http'
require 'json'

# this wierd name flip needed to be done as ruby does not allow leading digits in class-names
class Store4
  @@jsonFlag = '&output=json'

  def initialize(path)
    @sparqlEndpoint = path
  end

  def query(query)
    protoUri = @sparqlEndpoint + '?query=' + CGI.escape(query) + @@jsonFlag
    uri = URI.parse(protoUri)
    resp = Net::HTTP.get(uri)
    return JSON.parse(resp)
  end
end
