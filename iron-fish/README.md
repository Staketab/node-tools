# IRONFISH
## [COMPONENTS SETUP README](https://github.com/Staketab/node-tools/blob/main/components/README.md)
----------------

# ![alt_tag](src/iron.png) (DOCKER-COMPOSE) IRONFISH INSTALLER NODE/MINER
Script for installing Ironfish node and miner.  

### Install components:  
```
curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/components/install.sh | bash
```

(Optional) Specify NODENAME, GRAFFITI, THREADS and PORT in this line if you need `./config.sh -n NODENAME -g GRAFFITI -t THREADS -p PORT`  
Example `./config.sh -n staketab.com -g staketab -t 4 -p 9033`  
You can use like all variables, some or not use them at all.  

Configuring: 
```
wget https://raw.githubusercontent.com/Staketab/node-tools/main/iron-fish/config.sh \
&& chmod +x config.sh \
&& ./config.sh -n NODENAME -g GRAFFITI -t THREADS -p PORT \
&& rm -rf config.sh
```
Download docker-compose config:
```
. $HOME/.profile
wget https://raw.githubusercontent.com/Staketab/node-tools/main/iron-fish/docker-compose.yaml
```
Start Ironfish and Miner nodes:
```
docker-compose up -d
```
### Commands:  
`docker-compose down` - stop ironfish nodes  
`docker-compose logs -f ironfish` - ironfish logs  
`docker-compose logs -f ironfish-miner` - ironfish-miner logs  
  
# ![alt_tag](src/iron.png) (FROM SOURCE) IRONFISH INSTALLER NODE/MINER
Script for installing Ironfish node and miner.  

### Install components:  
```
curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/components/install.sh | bash
```

(Optional) Specify NODENAME, GRAFFITI, THREADS and PORT in this line if you need `./ironfish.sh -n NODENAME -g GRAFFITI -t THREADS -p PORT`  
Example `./ironfish.sh -n staketab.com -g staketab -t 4 -p 9033`  
You can use like all variables, some or not use them at all.  

Configuring: 
```
wget https://raw.githubusercontent.com/Staketab/node-tools/main/iron-fish/ironfish.sh \
&& chmod +x ironfish.sh \
&& ./ironfish.sh -n NODENAME -g GRAFFITI -t THREADS -p PORT \
&& rm -rf ironfish.sh
```
### Commands:  
`sudo systemctl stop ironfish` - stop ironfish node  
`sudo systemctl stop ironfish-miner` - stop ironfish miner  
`sudo journalctl -u ironfish -f --line 100` - ironfish logs  
`sudo journalctl -u ironfish-miner -f --line 100` - ironfish-miner logs  

## To run the CLI command use `$RUN` env:  
`$RUN version` - Ironfish node version  
`$RUN status -f` - node status  
`$RUN accounts:balance` - account balance  
`$RUN peers:list -f` - list of all connected peers  
`$RUN reset` - deletes your chain and wallet state, but preserves your accounts  

## Export/Import keys:  
`$RUN accounts:which` - your KEY_NAME  
`$RUN accounts:export $KEY_NAME $HOME/.ironfish/keys/$KEY_NAME.json` - export account to the file(backup)  
`$RUN accounts:import $HOME/.ironfish/keys/KEY_NAME.json` - import account from file  

All CLI commands - [Ironfish CLI](https://ironfish.network/docs/onboarding/iron-fish-cli).  

## Cleaning the system from Ironfish:  
```
curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/iron-fish/del-deps.sh | bash
```

### DONE
