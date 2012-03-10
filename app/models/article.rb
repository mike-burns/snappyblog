require 'pending'

class Article < ActiveRecord::Base
  def self.all_with_pending
    all + pending(:article)
  end

  def pending?
    false
  end
end
