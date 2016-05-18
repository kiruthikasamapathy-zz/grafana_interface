require 'docker-api'
require 'serverspec'
require 'fileutils'
require 'shellwords'
require 'json'
require "rspec/wait"

GRAFANA_VERSION=ENV['GRAFANA_VERSION'] || "latest"
GRAFANA_IMAGE_REPO=ENV['GRAFANA_IMAGE_REPO'] || 'grafana-interface-spec'
GRAFANA_IMAGE_TAG=ENV['GRAFANA_IMAGE_TAG'] || 'local-build'
DEPLOY_ENVIRONMENT=ENV['DEPLOY_ENVIRONMENT'] || 'local'

describe "Dockerfile" do
  before(:all) do
    build_args = {
      'DEPLOY_ENVIRONMENT' => "#{DEPLOY_ENVIRONMENT}"
    }
    @image = Docker::Image.build_from_dir('build', {"buildargs" => JSON.generate(build_args)})
    @image.tag(:repo => GRAFANA_IMAGE_REPO, :tag => GRAFANA_IMAGE_TAG, :force=> true)
    @image.tag(:repo => GRAFANA_IMAGE_REPO, :tag => GRAFANA_VERSION, :force=> true)
  end

  describe "#filesystem" do
    before (:all) do
      set :backend, :docker
      set :os, :family => 'redhat', :release => 7
      set :docker_image, @image.id
      set :docker_container_create_options, 'Cmd' => ['/bin/sh']
    end

    after (:all) do
      RSpec.configuration.docker_image = nil
      Specinfra::Configuration.instance_variable_set("@docker_image", nil)
      ::Specinfra::Backend::Docker.clear
    end

    describe file ('/usr/share/grafana/conf/defaults.ini') do
      it {should be_file }
    end

    describe file('/usr/share/grafana/conf/defaults.ini') do
      it { should contain '[dashboards.json]
      enabled = true
      path = /var/lib/grafana/dashboards' }
    end

    describe file ('/var/lib/grafana/dashboards/info.json') do
      it {should be_file }
    end

    describe file ('/var/lib/grafana/dashboards/kana.json') do
      it {should be_file }
    end

    describe file ('/var/lib/grafana/dashboards/spog.json') do
      it {should be_file }
    end

    describe file ('/usr/share/grafana/scripts/add_influxdb.sh') do
      it {should be_file }
    end

    describe file ('/usr/share/grafana/scripts/add_influxdb.sh') do
      it { should be_executable }
    end

    describe file ('/etc/supervisord.conf') do
     it {should be_file }
   end
  end

  describe 'Dockerfile#running' do
    before(:all) do
      #Docker.logger = Logger.new(STDOUT)
      @running_container = Docker::Container.create(
      'Image'=>@image.id)
      @running_container.start( :detach => true )
      set :backend, :docker
      set :os, :family => 'redhat', :release => 7
      set :docker_image, nil
      set :docker_container, @running_container.id
    end

    after(:all) do
      @running_container.kill
      @running_container.remove
    end

    describe service('grafana-server'), :wait => {:delay =>2, :timeout => 10 } do
      it "should be running" do
        wait_for(subject).to be_running
      end
    end
  end
end
