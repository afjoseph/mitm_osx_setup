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
