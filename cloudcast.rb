require './mixcloud_object.rb'

# Some intance Variables of the following class are dynamically created by the super-class MixcloudObject
# These should be: @description, @tags(holding an array of hashes), @play_count, @user(holding a hash), @key, @created_time
#                  @audio_length, @slug, @favorite_count, @listener_count, @name, @url, @pictures(holding a hash)
#                  @repost_count, @updated_time, @picture_primary_color, @comment_count and @sections(holding an array of hashes)
class CloudCast < MixcloudObject
  def initialize(path)
    super(path)

    # the formula for calculating the rating may need some more work
    @rating = ((@favorite_count+1)*(@repost_count+1)).to_f/@play_count 
    tracklist = []
    @sections.each do |t|
      tracklist << t["track"]["artist"]["slug"]+'/'+t["track"]["slug"]+'/'
    end
    @sections = tracklist
  end

  def getPrev(path)
    i = @sections.index path
    raise "Track not present" unless i
    raise "No previous Track" if i == 0
    return @sections[i-1]
  end

  def getNext(path)
    i = @sections.index path
    raise "Track not present" unless i
    raise "No next Track" if i == @sections.length-1
    return @sections[i+1]
  end
end
