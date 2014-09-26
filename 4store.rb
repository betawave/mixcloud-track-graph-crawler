require 'cgi'
require 'net/http'
require 'json'

class SPARQLEndpoint
  def initialize(path)
    @sparqlEndpoint = path
  end

  def query(query, *flags)
    # the following 4 lines kind of stink in my opinion, might be reduced with proper usage of the URI-class which is able to cope with params, but it didn't quite work out with me and this probably handsom[aka usefull] class on our first date, but I spoke with my (only imaginary, but hey.. better than nothin') bffl (in case you lived under a rock for the last few years: BestFriendForLive) and we figured that I should give him a second chance some day, works for now
    protoUri = @sparqlEndpoint + '?query=' + CGI.escape(query)
    flags.each do |flag|
      protoUri += flag
    end

    uri = URI.parse(protoUri)
    return Net::HTTP.get(uri)
  end
end

# this wierd name flip needed to be done as ruby does not allow leading digits in class-names
class Store4 < SPARQLEndpoint
  @@jsonFlag = '&output=json'

  def query(query)
    response = super(query, @@jsonFlag)
    return JSON.parse(response)
  end
end
