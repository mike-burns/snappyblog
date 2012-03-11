shared_examples 'resque job' do |constant|
  it 'declares a queue' do
    constant.instance_variable_get('@queue').should be_present
  end

  it 'defines the performing action' do
    constant.should respond_to(:perform)
  end
end
