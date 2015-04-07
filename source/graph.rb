require './4store.rb'

class RDFGraph
  def initialize(store, uri)
    @store = store
    self.find||create(uri)
  end

private
  # searches for the specified graph in the store
  #   if a graph whith the same uri is found, this one is used
  #   if no graph with that same uri is found, a new one gets created
  def find||create(uri)
    @store.query
  end
end
