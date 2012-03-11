require 'active_record_json'

ActiveRecord::Base.send(:include, ActiveRecordJson::InstanceMethods)
ActiveRecord::Base.send(:extend, ActiveRecordJson::ClassMethods)
