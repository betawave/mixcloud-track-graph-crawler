require './SPARQLEndpoint.rb'
require 'json'

# this wierd name flip needed to be done as ruby does not allow leading digits in class-names
class Store4 < SPARQLEndpoint
  @@jsonFlag = '&output=json'

  def run(query)
    response = super(query, @@jsonFlag)
    return JSON.parse(response)
  end
end
