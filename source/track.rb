require './mixcloud_object.rb'
require './cloudcast.rb'

# Some intance Variables of the following class are dynamically created by the super-class MixcloudObject
# These should be: @url, @artist(holding a Hash), @name, @key and @slug
class Track < MixcloudObject
  @@stem = 'track/'
  @@mixes = 'popular/' # other possibilities are 'new/' or 'hot/'

  def initialize(path)
    path = @@stem + path
    super(path)

    self.buildSubnet
  end

  # building the arrays which contain the information that should later on be stored in the RDF-Storage(in my case 4store)
  # These two arrays hold essentally all information need for one node inside the track-graph
  # As I'm still uncertain wether or not my Track graph should be a direct one I'm for the moment holding the diffent dirctions (in and out) in two diffent arrays
  def buildSubnet
    # Collecting "all" Mixes contaning the track from mixcloud 
    # creating new CloudCast-Objects for each and storing them for further processing in an array
    mixesPre = @@mixcloud.call(path + @@mixes)
    mixesPre = mixesPre["data"]
    mixes = []
    mixesPre.each do |mix|
      mixes <<  CloudCast.new(mix["user"]["username"]+'/'+mix["slug"]+'/')
    end

    path = @key[7..-1]
    @mixfrom = []
    @mixinto = []

    # destilling all the information I'm interested in out of the Cloudcast-Objects
    mixes.each do |m|
      begin
        track = {:path => m.getPrev(path),
                 :rating => m.getRating,
                 :mix => m.getPath}
        @mixfrom << track
      rescue Exception => e
      end
      begin
        track = {:path => m.getNext(path),
                 :rating => m.getRating,
                 :mix => m.getPath}
        @mixinto << track
      rescue Exception => e
      end
    end
  end

end
