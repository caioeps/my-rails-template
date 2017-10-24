class ApplicationDecorator < SimpleDelegator
  class << self
    def decorate_collection(collection)
      collection.map { |obj| new(obj) }
    end
  end

  private

  def object
    __getobj__
  end

  def helpers
    ApplicationController.helpers
  end
  alias_method :h, :helpers
end
