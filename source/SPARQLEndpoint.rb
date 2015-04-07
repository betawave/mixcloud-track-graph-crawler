require 'cgi'
require 'net/http'


# Need to not fail when uri contains curly braces
# This overrides the DEFAULT_PARSER with the UNRESERVED key, including '{' and '}'
# DEFAULT_PARSER is used everywhere, so its better to override it once
module URI
  remove_const :DEFAULT_PARSER
  unreserved = REGEXP::PATTERN::UNRESERVED
  DEFAULT_PARSER = Parser.new(:UNRESERVED => unreserved + "\{\}\<\>")
end


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
    queryElements = sparql.split(' ')
    
    # selects corret stem depnding on first keyword in the query
    update = @@updateVerbs.select { |verb|
      verb == queryElements[0]
    }.length() > 0
    query = @@queryVerbs.select { |verb|
      verb == queryElements[0]
    }.length() > 0

    if(update)
      protoUri = updateStem
    elsif(query)
      protoUri = queryStem
    end
    
    protoUri += queryElements.join('+')

    # appending all, other flags; the following 3 lines (and some others which are scattered across this class) kind of stink in my opinion, might be reduced with proper usage of the URI-class which is able to cope with params, but it didn't quite work out with me and this probably handsom[aka usefull] class on our first date, but I spoke with my bffl (although she's only imaginary, but hey.. better than nothin'; in case you lived under a rock for the last few years: BestFriendForLive) and we figured that I should give him a second chance some day, but for now I'll stick with good old string-manip even though he stinks a little when he comes back home from work, he at least dose the job without big chananigans
    flags.each do |flag|
      protoUri += flag
    end

    uri = URI.parse(protoUri)
    if(update)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path)
      http.request(req)
    elsif(query)
      return Net::HTTP.get(uri)
    end
    
  end

  def queryStem
    return @sparqlEndpoint + '?query='
  end

  def updateStem
    return @updateEndpoint + '?update='
  end
end
