## Gaia Domain
This project brings you the complete ecosystem of Gaia domain.

## Create your own domain
Following the steps below will allow you to create your own domain and allow nodes to join it.

### Download the repo
```shell
curl -L https://github.com/GaiaNet-AI/gaia-domain/archive/refs/tags/v0.1.1.zip -o gaia-domain.zip
unzip gaia-domain.zip -d gaia-domain
mv gaia-domain/*/* gaia-domain
```

### Build
```shell
cd gaia-domain
docker compose build
```

### Configure
Change `yourdomain.ai` to your domain name in the following files:
- frps/conf/frps.toml
- nginx/conf.d/domain.conf
- nginx/conf.d/hub.conf

Then at your domain provider, add the DNS record to your host IP.
Note that if your domain name is somedomain.ai, for example, you should add two A record with the name `somedomain.ai` and `*`. 

### Init db
```shell
curl -L https://raw.githubusercontent.com/GaiaNet-AI/gaia-hub/main/init.sh -o init.sh
sh init.sh
```

### Run
```shell
docker compose up
```

If you encountered warning in redis container like this:
```
	# WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition.
	Being disabled, it can also cause failures without low memory condition, see https://github.com/jemalloc/jemalloc/issues/1328.
	To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
```
Run following command to fix it:
```bash
echo 'vm.overcommit_memory = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

That's all. Your Gaia domain has started up.
In order for a Gaia node to join your domain, one thing needs to be changed on the node side before running "gaianet init".

- config.json
	The `domain` field should be change to your root domain name.
	The domain of `server_health_url` and `server_info_url` fields should be changed to `hub.domain.yourdomain` which exists in your hub.conf.