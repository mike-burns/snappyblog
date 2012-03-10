require 'active_model/naming'

class Pending
  extend ActiveModel::Naming

  def initialize(source_model_name)
    @model_name = "Pending#{source_model_name.to_s.capitalize}"
  end

  # This only exists for ActiveModel::Naming
  def class_with_model_name # :nodoc:
    self.class_without_model_name.tap do |c|
      c.instance_variable_set('@_model_name', @model_name)
      (class << c; self; end).send(:define_method,:model_name) do
        model_namer = Struct.new(:name).new(self.instance_variable_get('@_model_name'))
        ActiveModel::Name.new(model_namer)
      end
    end
  end
  alias class_without_model_name class
  alias class class_with_model_name

  def pending?
    true
  end
end

module PendingGenerator
  def pending(key)
    pending = []

    Resque.redis.llen("queue:#{key}").times do
      pending << Pending.new(key)
    end

    pending
  end
end

ActiveRecord::Base.extend(PendingGenerator)
