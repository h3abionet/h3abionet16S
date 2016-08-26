# rdna: a tool for 16S rRNA diversity analysis

Gophercloud is a flexible SDK that allows you to consume and work with OpenStack
clouds in a simple and idiomatic way using golang. Many services are supported,
including Compute, Block Storage, Object Storage, Networking, and Identity.
Each service API is backed with getting started guides, code samples, reference
documentation, unit tests and acceptance tests.

rdna is a flexible tool that allows you to choose a cloud provider, create virtual machines, upload data/workflow/licenses and run it. rdna is written in Go and published as a single binary, you should be able to download it and run it without any dependences.
 
## Useful links

* [Gophercloud homepage](http://gophercloud.io)
* [Reference documentation](http://godoc.org/github.com/rackspace/gophercloud)
* [Getting started guides](http://gophercloud.io/docs)
* [Effective Go](https://golang.org/doc/effective_go.html)

## How to install


```bash
$ wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/automation/rdna.tar.gz
$ gunzip rdna.gz
$ chmod +x rdna
$ ./rdna
usage: rdna server|workflow
```

## How to use

### List all the cloud providers
```bash
$ ./rdna server provider
+-------------+------+-----+-------------+------------+-------------+------------------------+
|    NAME     | VCPU | RAM |   STORAGE   |    I/O     | HOURLY COST |        PROVIDER        |
+-------------+------+-----+-------------+------------+-------------+------------------------+
| t2.micro    |    1 |   1 |          -- | Low        | $0.000      | Amazon EC2             |
| m4.xlarge   |    4 |  16 |          -- | High       | $0.239      | Amazon EC2             |
| m4.2xlarge  |    8 |  32 |          -- | High       | $0.479      | Amazon EC2             |
| m4.4xlarge  |   16 |  64 |          -- | High       | $0.958      | Amazon EC2             |
| m4.10xlarge |   40 | 160 |          -- | 10 Gigabit | $2.394      | Amazon EC2             |
| c4.2xlarge  |    8 |  15 |          -- | High       | $0.419      | Amazon EC2             |
| c4.4xlarge  |   16 |  30 |          -- | High       | $0.838      | Amazon EC2             |
| c4.8xlarge  |   36 |  60 |          -- | 10 Gigabit | $1.675      | Amazon EC2             |
| r3.large    |    2 |  15 | SSD 1 x  32 | Moderate   | $0.166      | Amazon EC2             |
| r3.xlarge   |    4 |  30 | SSD 1 x  80 | Moderate   | $0.333      | Amazon EC2             |
| r3.2xlarge  |    8 |  61 | SSD 1 x 160 | High       | $0.665      | Amazon EC2             |
| r3.4xlarge  |   16 | 122 | SSD 1 x 320 | High       | $1.330      | Amazon EC2             |
| r3.8xlarge  |   32 | 244 | SSD 2 x 320 | 10 Gigabit | $2.660      | Amazon EC2             |
| i2.xlarge   |    4 |  30 | SSD 1 x 800 | Moderate   | $0.853      | Amazon EC2             |
| i2.2xlarge  |    8 |  61 | SSD 2 x 800 | High       | $1.705      | Amazon EC2             |
| i2.4xlarge  |   16 | 122 | SSD 4 x 800 | High       | $3.410      | Amazon EC2             |
| i2.8xlarge  |   32 | 244 | SSD 8 x 800 | 10 Gigabit | $6.820      | Amazon EC2             |
| vm16        |    4 |  16 | SAS 1 x 100 | 10 Gigabit | $0.040      | SANBI                  |
| vm32        |    8 |  32 | SAS 1 x 200 | 10 Gigabit | $0.080      | SANBI                  |
| vm64        |   16 |  64 | SAS 1 x 400 | 10 Gigabit | $0.160      | SANBI                  |
| vm128       |   32 | 128 | SAS 1 x 800 | 10 Gigabit | $0.320      | SANBI                  |
| m1.large    |    4 |   8 | SAS 1 x 80  | 10 Gigabit | $0.0        | University of Illinois |
| m1.xlarge   |    8 |  16 | SAS 1 x 160 | 10 Gigabit | $0.0        | University of Illinois |
| local       |    8 |  16 | SAS 1 x 200 | 10 Gigabit | $0.0        | Local machine          |
+-------------+------+-----+-------------+------------+-------------+------------------------+
```

This will list all the cloud providers you can choose to run your workflows, you can 
also run it in your local machine.

### List all the servers

Once we have a cloud provider, we can list all the servers in that cloud:

```bash
$ ./rdna server list
+------------------+--------+----------------------+----------------+
|  INSTANCE NAME   | STATUS |       CREATED        |   PUBLIC IP    |
+------------------+--------+----------------------+----------------+
| h3abionet16sDemo | ACTIVE | 2016-08-25T16:23:24Z | 141.142.209.51 |
| node4            | ACTIVE | 2016-08-25T07:45:12Z | 141.142.209.50 |
| node3            | ACTIVE | 2016-08-25T07:44:57Z | 141.142.209.5  |
| node2            | ACTIVE | 2016-08-25T07:44:42Z | 141.142.209.3  |
| node1            | ACTIVE | 2016-08-25T07:44:27Z | 141.142.209.49 |
| node0            | ACTIVE | 2016-08-25T07:44:12Z | 141.142.209.33 |
| manager1         | ACTIVE | 2016-08-25T07:43:57Z | 141.142.209.48 |
| manager0         | ACTIVE | 2016-08-25T07:43:42Z | 141.142.209.34 |
| consul0          | ACTIVE | 2016-08-25T07:43:12Z | 141.142.209.32 |
| h3abionet16S     | ACTIVE | 2016-08-24T08:09:54Z | 141.142.209.30 |
+------------------+--------+----------------------+----------------+
```

### Provision a server

Then we can create a server/vm/instance in the cloud:

```bash
./rdna server create
```

### Install software, tools and dependencies

```bash
./rdna server install
```

### Terminate a server

```bash
./rdna server terminate
```

### Upload your workflows and data

```bash
./rdna workflow install
```

### Run it

```bash
./rdna workflow run
```

## Contributing

H3ABioNet is a Pan African Bioinformatics network comprising 32 Bioinformatics 
research groups distributed amongst 15 African countries and 2 partner Institutions 
based in the USA which will support H3Africa researchers and their projects while 
developing Bioinformatics capacity within Africa.


## Help and feedback

Engaging the community and lowering barriers for contributors is something we
care a lot about. If you're not sure how you can get involved, feel free to 
submit an issue to our [bug tracker](/issues) or [H3ABioNet](http://www.h3abionet.org/).

If you're struggling with something or have spotted a potential bug, feel free
to submit an issue to our [bug tracker](/issues).
