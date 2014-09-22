require './mixcloud.rb'

class MixcloudObject
  @@mixcloud = Mixcloud.new

  def initialize(path)
    hash = @@mixcloud.call(path)
    hash.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end
end
