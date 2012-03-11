require 'pending'

class Article < ActiveRecord::Base
  validates_presence_of :title, :body

  def self.all_with_pending
    all + pending(:article)
  end

  def self.new_from_json(json)
    if json
      JSON.parse(json)
    else
      new
    end
  end

  def pending?
    false
  end
end
