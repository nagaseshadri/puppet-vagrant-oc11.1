#!/usr/bin/env rspec

require 'spec_helper'

init_param, = Puppet::Type.type(:init_param)

describe init_param do

  let(:attribute_class) {  @class.attrclass(attribute_name) }
  let(:attribute) {@resource.property(attribute_name)}


  before(:each) do
    @class = init_param 
    @provider = double 'provider'
    allow(@provider).to receive(:name).and_return(:simple)
    allow(@class).to receive(:defaultprovider).and_return @provider
    class Puppet::Type::Init_param; def self.default_sid; 'TEST'; end; end
    @resource = @class.new({:name  => 'MEMORY_TARGET'})
  end


  it 'should have :name and :parameter_name be its namevar' do
    expect(@class.key_attributes).to eq([:name, :parameter_name, :instance])
  end

  describe ':paremeter_name' do

    let(:attribute_class) { @class.attrclass(:parameter_name) }

  	it 'should pick its value from element NAME' do
  		raw_resource = InstancesResults['NAME','memory_target']
  		expect(attribute_class.translate_to_resource(raw_resource)).to eq 'memory_target'
  	end

  	it 'should raise an error when name not found in raw_results' do
  		raw_resource = InstancesResults['NEMA','MY_NAME']
  		expect{attribute_class.translate_to_resource(raw_resource)}.to raise_error(RuntimeError)
  	end

    it 'should munge to uppercase' do
      @resource[:parameter_name] = 'sga_target'
      expect(@resource[:parameter_name]).to eq 'sga_target'
    end

    it 'should not accept a name with whitespace' do
      expect{@resource[:parameter_name] = 'a a' }.to raise_error(Puppet::Error)
    end

    it 'should not accept an empty name' do
      expect{@resource[:parameter_name] = '' }.to raise_error(Puppet::Error)
    end

    it_behaves_like 'an easy_type attribute', {
      :attribute          => :parameter_name,
      :result_identifier  => 'NAME',
      :raw_value          => 'MEMORY_TARGET',
      :test_value         => 'MEMORY_TARGET',
    }
  end

  describe ':value' do

    let(:attribute_name) { :value}

    context "when geting data from the system" do

      it 'should raise an error when name not found in raw_results' do
        raw_resource = InstancesResults['NAME','MY_NAME']
        expect{attribute_class.translate_to_resource(raw_resource)}.to raise_error(RuntimeError)
      end

      it 'should pick its value from element DISPLAY_VALUE' do
        raw_resource = InstancesResults['DISPLAY_VALUE','42G']
        expect(attribute_class.translate_to_resource(raw_resource)).to eq '42G' 
      end

    end

    context "base parameter settings" do
      it 'should accept a value and not modify it' do
        @resource[:value] = 'none'
        expect(@resource[:value]).to eq 'none'
      end

    end

  end

end
