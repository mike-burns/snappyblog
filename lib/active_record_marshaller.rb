class ActiveRecordMarshaller
  def initialize(an_active_record)
    @an_active_record = an_active_record
  end

  def as_json(*a)
    {'json_class' => self.class.name,
      'data' => {
        'active_record_class' => @an_active_record.class.name,
        'errors' => @an_active_record.errors.to_hash,
        'attributes' => @an_active_record.attributes}}.as_json(*a)
  end

  def to_json(*a)
    as_json.to_json(*a)
  end

  def self.json_create(o)
    factory_class = o['data']['active_record_class'].constantize
    factory_class.new(o['data']['attributes']).tap do |article|
      o['data']['errors'].each do |key, messages|
        messages.each do |message|
          article.errors.add(key, message)
        end
      end
    end
  end

  def ==(o)
    as_json == o.as_json
  end
end
