# Docker安装mysql



# Docker安装mysql

```shell
$ docker pull mysql:latest
$ cd ~
$ mkdir mysql
$ cd mysql
```

```shell
$ docker run -p 3306:3306 --name mysql -v $PWD/conf/my.cnf:/etc/mysql/my.cnf -v $PWD/logs:/logs -v $PWD/data:/mysql_data -e MYSQL_ROOT_PASSWORD=123456 -d mysql
```

# 连接mysql
&gt; https://docs.fedoraproject.org/en-US/quick-docs/installing-mysql-mariadb/
&gt; 可以参考一下官方文档

```shell
$ sudo dnf install community-mysql-server
```

```shell
$ mysql -h 127.0.0.1 -P 3306 -u root -p123456
```

---

> 作者: meowrain  
> URL: https://example.org/posts/e3c5896/  

