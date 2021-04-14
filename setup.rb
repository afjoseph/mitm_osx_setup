#!/usr/bin/env ruby
# frozen_string_literal: true

# rubocop:disable Lint/RedundantCopDisableDirective, Lint/MissingCopEnableDirective, Style/LineTooLong, Metrics/BlockLength, Metrics/ParameterLists, Metrics/MethodLength, Metrics/AbcSize, Style/IfUnlessModifier, Metrics/CyclomaticComplexity, Layout/LineLength, Metrics/PerceivedComplexity

def log_info(msg)
  puts "[#{File.basename(__FILE__)}][+] #{msg}"
end

def log_system(msg)
  puts "[#{File.basename(__FILE__)}][+] #{msg}"
end

def log_error(msg)
  puts "[#{File.basename(__FILE__)}][!] #{msg}"
end

def die!(msg = '')
  caller_infos = caller.first.split(':')
  log_error "Died @#{caller_infos[0]}:#{caller_infos[1]}: #{msg}"
  exit 1
end

def system_or_die!(cmd, msg = nil, env = nil)
  log_system cmd
  if env.nil?
    unless system(cmd)
      s = "FAIL: #{cmd}"
      s += " #{msg}" unless msg.nil?
      die! s
    end
  else
    die! "FAIL: #{cmd} #{msg}" unless system(env, cmd)
  end
end

def main
  die! 'No argument. Pass either "enable" or "disable"' if ARGV[0].nil?
  enable = ARGV[0].downcase.strip == 'enable'
  service_name = 'USB 10/100/1000 LAN 3'
  mitmproxy_cert_pem_path = '~/.mitmproxy/mitmproxy-ca-cert.pem'
  listen_port = '3223'

  log_info "[+] enable: #{enable}"
  log_info "[+] service_name: #{service_name}"
  case enable
  when true
    log_info '[+] Adding mitmproxy certs to keychain...'
    system_or_die! "sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain #{mitmproxy_cert_pem_path}"
    log_info '[+] Enabling ipforwarding...'
    system_or_die! 'sudo sysctl -w net.inet.ip.forwarding=1'
    log_info '[+] Setting proxy off...'
    system_or_die! "sudo networksetup -setsecurewebproxy '#{service_name}' 127.0.0.1 #{listen_port}"
    system_or_die! "sudo networksetup -setwebproxy '#{service_name}' 127.0.0.1 #{listen_port}"
  when false
    log_info '[+] Removing mitmproxy certs to keychain...'
    # XXX Can fail if already removed
    `sudo security remove-trusted-cert -d #{mitmproxy_cert_pem_path}`
    log_info '[+] Disabling ipforwarding...'
    system_or_die! 'sudo sysctl -w net.inet.ip.forwarding=0'
    log_info '[+] Setting proxy off...'
    system_or_die! "sudo networksetup -setsecurewebproxystate '#{service_name}' off"
    system_or_die! "sudo networksetup -setwebproxystate '#{service_name}' off"
  end
  log_info '[+] DONE: run "sudo mitmproxy --showhost -p 3223"'
end

main
