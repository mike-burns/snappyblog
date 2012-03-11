require 'pending'

class Article < ActiveRecord::Base
  validates_presence_of :title, :body

  def self.all_with_pending
    all + pending(:article)
  end
end
