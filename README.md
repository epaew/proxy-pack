# Proxy pack

## What is?
Use SOCKS proxy from iOS devices

## Requirements
* PC (macOS/Linux)
  * Ruby
  * SSH
* iOS device

## How to use
1. (PC) Clone this repo
    ```sh
    git clone git@github.com:epaew/proxy-pack.git
    cd proxy-pack/
    ```
2. (PC) Install the required gems
    ```sh
    gem install bundler # If has not installed.
    bundle install
    ```
3. (PC) Create .env file
    ```sh
    cp .env{.example,}
    vim .env
    ```
4. (PC) Start SSH and HTTP processes
    ```sh
    bundle exec foreman start
    ```
5. (iPhone) Set the HTTP proxy
    * Settings -> Wi-Fi -> (i) on the right side of SSID -> Configure Proxy -> Automatic
    * Set the URL w/ `http://(IP address of your PC):(WEB_PORT in your .env)/proxy.pac`
