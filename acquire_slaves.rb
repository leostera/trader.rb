require 'pry'

require 'nokogiri'
require 'net/ssh'
require 'jenkins_api_client'
require 'commander'

Commander.configure do

  program :name, 'Slave Trader'
  program :version, :alpha
  program :description, 'Trigger Reassoaciation of a Slave with a Jenkins Instance'

  command :move do |c|

    c.option '--label NAME', String, 'The label to add to this nodes'
    c.option '--jenkins URL', String, 'The url of the jenkins instance to associate this slaves with'
    c.option '--username NAME', String, 'Username to login with'
    c.option '--token TOKEN', String, 'Token to login with'
    c.option '--fqdn FQDN', String, 'Domain Suffix (<slave-name>.some.internal.domain)'
    c.option '--port PORT', Integer, 'Port to connect to (22)'
    c.option '--mode MODE', String, 'NORMAL or EXCLUSIVE'
    c.option '--home PATH', String, 'Path to jenkins home'

    c.action do |args, options|
      unless options.username and options.token and options.jenkins
        puts "At least specify username, token, and jenkins url."
        puts "Run   rb acquire_slaves.rb --help move   for help."
        exit 1
      end

      jenkins = JenkinsApi::Client.new(
        :server_url => "https://#{options.jenkins}:443",
        :username   => options.username,
        :password   => options.token,
      )

      jenkins_test = jenkins.get_root
      return jenkins_test unless jenkins_test.code == "200"

      password = password 'Please enter your ssh password:', '*'

      slaves = args.map do |name|
        post_params = {
          "name" => name,
          "type" => "hudson.slaves.DumbSlave$DescriptorImpl",
          "json" => {
            "name" => name,
            "nodeDescription" => name,
            "numExecutors" => 1,
            "remoteFS" => options.home,
            "labelString" => options.label,
            "mode" => options.mode.upcase,
            "type" => "hudson.slaves.DumbSlave$DescriptorImpl",
            "retentionStrategy" => {
              "stapler-class" => "hudson.slaves.RetentionStrategy$Always"
            },
            "nodeProperties" => {
              "stapler-class-bag" => "true"
            },
            "launcher" => {
              "stapler-class" => "hudson.slaves.JNLPLauncher"
            }
          }.to_json
        }

        puts " > Creating Slave: #{name}"
        jenkins.api_post_request("/computer/doCreateItem", post_params)
        res = jenkins.api_get_request("/computer/#{name}")
        p res

        puts " > Fetching jnlp start command..."
        raw = jenkins.api_get_request("/computer/#{name}", nil, "/")
        cmd = Nokogiri::HTML(raw).css("pre").first.text
        p cmd

        puts " > Running command remotely..."

        ssh = Net::SSH.start("#{name}.#{options.fqdn}", options.username, password: password)
        ssh.exec "${cmd} &"

        jenkins.api_get_request("/computer/#{name}")
      end

      pp  slaves
    end

  end

  default_command :move

end
