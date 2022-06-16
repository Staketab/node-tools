# BITCOIN NODE TESTNET

(Options) Specify USERNAME and RPCPORT in this line if you need `./setup.sh -u USERNAME -p RPCPORT -c CHAIN`  
Example `./setup.sh -u staketab -p 8332 -c CHAIN`  
You can use like all variables, or only `USERNAME` and `CHAIN`.  

### Start: 
```
wget https://raw.githubusercontent.com/Staketab/node-tools/main/btc/setup.sh \
&& chmod +x setup.sh \
&& ./setup.sh -u staketab -p 8332 -c mainnet
```
### Commands:  
Start BTC node service:  
```
sudo systemctl start btc.service
```
Stop BTC node service:  
```
sudo systemctl stop btc.service
```
BTC node service logs:
```
sudo journalctl -u btc.service -f --line 100
```

### DONE
