require 'spec_helper'
describe Puppet::Type.type(:rabbitmq_user) do
  before :each do
    @user = Puppet::Type.type(:rabbitmq_user).new(:name => 'foo', :password => 'pass')
  end
  it 'should accept a user name' do
    @user[:name] = 'dan'
    @user[:name].should == 'dan'
    @user[:admin].should == :false
  end
  it 'should accept a password' do
    @user[:password] = 'foo'
    @user[:password].should == 'foo'
  end
  it 'should require a password' do
    expect {
      Puppet::Type.type(:rabbitmq_user).new(:name => 'foo')
    }.to raise_error(/must set password/)
  end
  it 'should require a name' do
    expect {
      Puppet::Type.type(:rabbitmq_user).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  it 'should not allow whitespace in the name' do
    expect {
      @user[:name] = 'b r'
    }.to raise_error(Puppet::Error, /Valid values match/)
  end
  [true, false, 'true', 'false'].each do |val|
    it "admin property should accept #{val}" do
      @user[:admin] = val
      @user[:admin].should == val.to_s.to_sym
    end
  end
  it 'should not accept non-boolean values for admin' do
    expect {
      @user[:admin] = 'yes'
    }.to raise_error(Puppet::Error, /Invalid value/)
  end
  it 'should not accept tags with spaces' do
    expect {
      @user[:tags] = ['policy maker']
    }.to raise_error(Puppet::Error, /Invalid tag/)
  end
  it 'should not accept the administrator tag' do
    expect {
      @user[:tags] = ['administrator']
    }.to raise_error(Puppet::Error, /must use admin property/)
  end
end
