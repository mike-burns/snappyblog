module ActiveRecordJson
  module InstanceMethods
    def as_json(*a)
      {'json_class' => self.class.name,
        'data' => {
          'errors' => errors.to_hash,
          'attributes' => attributes}}.as_json(*a)
    end

    def to_json(*a)
      as_json.to_json(*a)
    end
  end

  module ClassMethods
    def json_create(o)
      new(o['data']['attributes']).tap do |article|
        o['data']['errors'].each do |key, messages|
          messages.each do |message|
            article.errors.add(key, message)
          end
        end
      end
    end

    def new_from_json(json)
      if json
        JSON.parse(json)
      else
        Article.new
      end
    end
  end
end
