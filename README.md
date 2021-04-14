Setup a mitmproxy to listen and capture HTTPS traffic on OSX

# Dependencies
* Ruby 2.0+
* mitmproxy 6.0+
* Tested on OSX 10.15 (BigSur)

# Usage
* Run `mitmproxy` once to generate some root certificates in `~/.mitmproxy`
* Run `setup.rb enable`
  * The interface name, port and location of mitmproxy certs are hard-coded in `setup.rb:main()`. Change them from there
* Run `sudo mitmproxy --showhost -p 3223`

# Capturing HTTPS browser traffic on a Macos machine
The above method works just fine for browser traffic, but if you want an easier situation with no certs, do this:
* download a different browser (just to make it easier to differentiate your captured session). Let's say `chromium` (`brew install chromium`)
* Run chromoim like this: `chromium --ssl-key-log-file=~/hello.log`
* Run a wireshark session, capture the traffic you need, and dump the pcap file
* All keys the browser makes for comms will be dumped to `~/hello.log`
* Now [go to this page](https://wiki.wireshark.org/TLS) and add the keys to a wireshark dump and follow the steps to use the keys
* FYI: `mitmproxy` respects `SSLKEYLOGFILE` environment variable, so you can technically run it like this and then do your capture in wireshark: `SSLKEYLOGFILE=~/hello.log sudo mitmproxy`
