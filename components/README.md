# Node Tools
List of tools for Node projects.

# ![alt_tag](src/ubuntu.png) UBUNTU COMPONENTS FULL SETUP
Installation script include:  
`- Docker`  
`- Docker-compose`  
`- build-essential`  
`- ocaml ocamlbuild`  
`- automake autoconf`  
`- libtool`  
`- wget`  
`- python`  
`- libssl-dev`  
`- git`  
`- cmake make`  
`- perl`  
`- tmux`  
`- ufw`  
`- gcc`  
`- unzip zip`  
`- jq`  
`- golang-statik`  

```
curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/components/install.sh | bash
```

# ![alt_tag](src/ubuntu.png) DOCKER + DOCKER-COMPOSE SETUP
Installation script include:  
`- Docker`  
`- Docker-compose`  

```
curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/docker/install.sh | bash
```

# ![alt_tag](src/go.png) GOLANG #GO
Install custom version of Golang #GO.  
Specify version in this line `./install.sh -v VERSION`  
Example `./install.sh -v 1.15.7`    

Or you can install GO from [official website](https://golang.org/doc/install).
```
wget https://raw.githubusercontent.com/Staketab/node-tools/main/components/golang/install.sh \
&& chmod +x install.sh \
&& ./install.sh -v 1.15.7
```
Reboot your terminal after installing.  

# ![alt_tag](src/python.png) PYTHON CUSTOM VERSION
Script for installing Python custom version.  
Specify TAG and VERSION in this line `bash -s VERSION`  
Example `bash -s 3.8.5`  
```
curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/components/python/install.sh | bash -s 3.8.5
```

# USERNAME SETUP
Script for installing new user.  
```
wget https://raw.githubusercontent.com/Staketab/node-tools/main/components/user/new.sh \
&& chmod +x new.sh \
&& ./new.sh
```

### DONE