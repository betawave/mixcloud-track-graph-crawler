require 'cgi'
require 'net/http'

class SPARQLEndpoint
  # taken from: w3:/TR/sparql11-update/
  @@updateVerbs = ['INSERT', 'DELETE', 'LOAD', 'CLEAR', 'CREATE', 'DROP', 'COPY', 'MOVE', 'ADD']
  # taken from: w3:/TR/rdf-sparql-query/
  @@queryVerbs = ['SELECT', 'CONSTRUCT', 'ASK', 'DESCRIBE']

  def initialize(host, queryPath, updatePath)
    @sparqlEndpoint = host + queryPath
    @updateEndpoint = host + updatePath
  end

  def run(sparql, *flags)
    sparql.split(' ')

    protoUri += CGI.escape(sparql)

    # appending all, other flags; the following 3 lines (and some others which are scattered across this class) kind of stink in my opinion, might be reduced with proper usage of the URI-class which is able to cope with params, but it didn't quite work out with me and this probably handsom[aka usefull] class on our first date, but I spoke with my bffl (although she's only imaginary, but hey.. better than nothin'; in case you lived under a rock for the last few years: BestFriendForLive) and we figured that I should give him a second chance some day, but for now I'll stick with good old string-manip even though he stinks a little when he comes back home from work, he at least dose the job without big chananigans
    flags.each do |flag|
      protoUri += flag
    end

    uri = URI.parse(protoUri)
    return Net::HTTP.get(uri)
  end

  def queryStem
    return @sparqlEndpoint + '?query='
  end

  def updateStem
    return @updateEndpoint + '?update='
  end
end
