# AutoTor FOR MAC OS

Install Tor Client on your Mac with one click and set the duration to change your IP address periodically.

## Installation

### Step 1: Open Terminal

Open the terminal and set up HomeBrew if you have not installed it. Follow instructions at [HomeBrew](https://brew.sh/).

### Step 2: Install Tor

```bash
brew install tor
```

````

### Step 3: Navigate to Tor Configuration

```bash
cd /opt/homebrew/opt/tor/
```

### Step 4: Copy torrc.sample

```bash
cp torrc.sample torrc
```

### Step 5: Clone AutoTor Repository

Open a new terminal window and run the following command:

```bash
git clone https://github.com/grezzled/AutoTor.git
```

### Step 6: Navigate to AutoTor Folder

```bash
cd AutoTor
```

### Step 7: Set Permissions

```bash
sudo chmod 777 ./autotor.sh
```

### Step 8: Run AutoTor

```bash
./autotor.sh
```

## Features:

- Setup HomeBrew if not already installed on your macOS
- Install Tor using brew if not already installed
- Locate and rename the torrc file
- Enable SOCKS Proxy and configure Server name (127.0.0.1) & port number to use when contacting the proxy server (9050)
- Custom duration (in seconds) to change Tor client IP address

![AutoTor Demo](cap.gif)
````
