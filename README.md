# ProxySQL Docker Container #

* [2.0.5](https://github.com/stacywebb/proxysql_docker_container/blob/master/Dockerfile)


## Overview ##

ProxySQL is a high-performance SQL proxy. Details at [ProxySQL](http://www.proxysql.com/) website.

## Image Description ##

* mysql client
* ProxySQL package for CentOS

To add the repo:

```bash
$ cat <<EOF | tee /etc/yum.repos.d/proxysql.repo \
[proxysql_repo] \
name= ProxySQL YUM repository \
baseurl=https://repo.proxysql.com/ProxySQL/proxysql-2.0.x/centos/\$releasever \
gpgcheck=1 \
gpgkey=https://repo.proxysql.com/ProxySQL/repo_pub_key \
EOF \
```

## Run ##

Running a ProxySQL container with a custom ProxySQL configuration file:
```bash
$ docker run -d \
--name proxysql \
--publish 6033:6033 \
--publish 6032:6032 \
--publish 6080:6080 \
--restart=unless-stopped \
-v /root/proxysql/proxysql.cnf:/etc/proxysql.cnf \
pwcdockerhub/proxysql:1.0
```

## Example Configurations, proxysql.cnf ##

ProxySQL configuration:
- [ProxySQL 2.0.5 with MySQL Conf]

Detailed examples of proxysql.cnf located: https://github.com/sysown/proxysql/blob/master/doc/configuration.md

Additional admin and mysql variables that can be applied: https://raw.githubusercontent.com/sysown/proxysql/master/doc/global_variables.md


Below configs are for reference only.

Usernames, passwords and ports should be changed accordingly.

### ProxySQL 2.0.5 with stats at port 6080 ###

```bash
datadir="/var/lib/proxysql"

admin_variables={
	admin_credentials="admin:!QAZ2wsx"
	mysql_ifaces="0.0.0.0:6032"
	refresh_interval=2000
	web_enabled=true
	web_port=6080
	stats_credentials="stats:admin"
}

mysql_variables={
	threads=4
	max_connections=1024
	default_query_delay=0
	default_query_timeout=36000000
	have_compress=true
	poll_timeout=2000
	interfaces="0.0.0.0:6033;/tmp/proxysql.sock"
	default_schema="information_schema"
	stacksize=1048576
	server_version="5.1.30"
	connect_timeout_server=10000
	monitor_history=60000
	monitor_connect_interval=200000
	monitor_ping_interval=200000
	ping_interval_server_msec=10000
	ping_timeout_server=200
	commands_stats=true
	sessions_sort=true
	monitor_username="proxysql"
	monitor_password="1qaz@WSX"
}


mysql_servers = 
(
	{ 
		address="127.0.0.1",
		port=3306,
		hostgroup=0,
		max_connections=100
	}
)

mysql_users:
(
        {
                username = "pwcuser",
                password = "#EDC4rfv",
                default_hostgroup = 0,
                transaction_persistent = 0,
                active = 1
        },
        {
                username = "pwcclient",
                password = "3edc$RFV",
                default_hostgroup = 1,
                transaction_persistent = 0,
                active = 1
        }
)


mysql_query_rules:
(
	{
		rule_id=100
		active=1
		match_pattern="^SELECT .* FOR UPDATE"
		destination_hostgroup=0
		apply=1
	},
	{
		rule_id=200
		active=1
		match_pattern="^SELECT .*"
		destination_hostgroup=1
		apply=1
	}
)

```
