# Node Tools
List of tools for Node projects.

## [COMPONENTS SETUP README](https://github.com/Staketab/node-tools/blob/main/components/README.md)
----------------

# ![alt_tag](src/avax.png) AVALANCHE INSTALLER/UPDATER  
Script for installing and updating Avalanche node from binary.  
Specify TAG and VERSION in this line `bash -s TAG VERSION`  
Example `bash -s 1.4.9 1.4.9`  
```
curl -s https://raw.githubusercontent.com/Staketab/node-tools/main/avalanche/install-upd.sh | bash -s 1.4.9 1.4.9
```

# ![alt_tag](src/iron.png) IRONFISH INSTALLER NODE/MINER
Script for installing Ironfish node and miner.  

(Optional) Specify THREADS and PORT in this line if you need `./config.sh THREADS PORT`  
Example `./config.sh --threads=4 --port=9033`  
  
Configuring: 
```
wget https://raw.githubusercontent.com/Staketab/node-tools/main/iron-fish/config.sh \
&& chmod +x config.sh \
&& ./config.sh
```
Download docker-compose config:
```
wget https://raw.githubusercontent.com/Staketab/node-tools/main/iron-fish/docker-compose.yaml
```
Start Ironfish and Miner nodes:
```
docker-compose up -d
```
### Commands:  
`docker-compose down` - stop ironfish node  
`docker-compose logs -f ironfish` - ironfish logs  
`docker-compose logs -f ironfish-miner` - ironfish-miner logs  

### To run the CLI command use `$RUN` env:  
`$RUN status -f` - node status  
`$RUN accounts:balance` - account balance  
`$RUN peers:list -f` - list of all connected peers  
`$RUN reset` - deletes your chain and wallet state, but preserves your accounts  

All CLI commands - [Ironfish CLI](https://ironfish.network/docs/onboarding/iron-fish-cli).

### DONE
