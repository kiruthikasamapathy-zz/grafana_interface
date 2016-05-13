require 'docker-api'
require 'serverspec'
require 'fileutils'
require 'shellwords'
require 'json'

describe "Dockerfile" do
  before(:all) do
    FileUtils.rm_r("build") if Pathname("build").exist?
    FileUtils.mkdir_p("build")
    FileUtils.copy_file("src/templates/Dockerfile.tmpl", "build/Dockerfile")

    FileUtils.cp_r("src/config/.", "build/.", :preserve=>true)
    FileUtils.cp_r("src/dashboards/", "build/.", :preserve=>true)
    build_args = {
    }
    @image = Docker::Image.build_from_dir('build', {"buildargs" => JSON.generate(build_args)})
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
  end

  # describe 'Dockerfile#running' do
  #   before(:all) do
  #     #Docker.logger = Logger.new(STDOUT)
  #     @running_container = Docker::Container.create(
  #     'Cmd'=>["/go", "start"],
  #     'Image'=>@image.id,
  #     'HostConfig' => {
  #         'PortBindings' => { "#{REMOTE_AGENTS_PORT}/tcp" => [{ 'HostPort' => "#{REMOTE_AGENTS_PORT}" }] }
  #       },
  #     'Env'=>[
  #       'BAMBOO_SERVICE_UID=501',
  #       'BAMBOO_SERVICE_GID=501'
  #     ])
  #     @running_container.start( :detach => true )
  #     # puts @running_container.json
  #     set :backend, :docker
  #     set :os, :family => 'redhat', :release => 7
  #     set :docker_image, nil
  #     set :docker_container, @running_container.id
  #   end
  #
  #   after(:all) do
  #     @running_container.kill
  #     @running_container.remove
  #   end
  #
  #   describe service('bamboo'), :wait => {:delay =>2, :timeout => 10 } do
  #     it "should be running" do
  #       wait_for(subject).to be_running.under('supervisor')
  #     end
  #   end
  #
  #   describe port("#{BAMBOO_SERVICE_PORT}"), :wait => { :delay => 1, :timeout => 10 } do
  #     it "should be listening" do
  #       wait_for(subject).to be_listening
  #     end
  #   end
  #
  #   describe 'Remote agents port #{REMOTE_AGENTS_PORT}' do
  #     it "should be exposed" do
  #       expect(@image.json['ContainerConfig']['ExposedPorts']).to include("#{REMOTE_AGENTS_PORT}/tcp")
  #     end
  #   end
  #
  #   describe file("/usr/local/bamboo/current/temp") do
  #     it {should be_writable }
  #   end
  #
  #   describe file('/home/bamboo/') do
  #     it {should exist}
  #   end
  #
  # end
end
