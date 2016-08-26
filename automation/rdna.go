package main

import (
	"bytes"
	"encoding/csv"
	"fmt"
	"os"
	"os/exec"
	"io/ioutil"
	"net/smtp"

	"golang.org/x/crypto/ssh"

	"github.com/olekukonko/tablewriter"

	"github.com/rackspace/gophercloud"
	"github.com/rackspace/gophercloud/openstack"
	"github.com/rackspace/gophercloud/openstack/compute/v2/extensions/keypairs"
	"github.com/rackspace/gophercloud/openstack/compute/v2/servers"
	"github.com/rackspace/gophercloud/openstack/compute/v2/extensions/floatingip"
	"github.com/rackspace/gophercloud/pagination"

)

const (
	Reset      = "\x1b[0m"
	Bright     = "\x1b[1m"
	Dim        = "\x1b[2m"
	Underscore = "\x1b[4m"
	Blink      = "\x1b[5m"
	Reverse    = "\x1b[7m"
	Hidden     = "\x1b[8m"
	FgBlack    = "\x1b[30m"
	FgRed      = "\x1b[31m"
	FgGreen    = "\x1b[32m"
	FgYellow   = "\x1b[33m"
	FgBlue     = "\x1b[34m"
	FgMagenta  = "\x1b[35m"
	FgCyan     = "\x1b[36m"
	FgWhite    = "\x1b[37m"
	BgBlack    = "\x1b[40m"
	BgRed      = "\x1b[41m"
	BgGreen    = "\x1b[42m"
	BgYellow   = "\x1b[43m"
	BgBlue     = "\x1b[44m"
	BgMagenta  = "\x1b[45m"
	BgCyan     = "\x1b[46m"
	BgWhite    = "\x1b[47m"
)

var (
    PublicIP = "141.142.209.51"
)

type Plan struct {
	name     string
	vcpu     string
	ram      string
	storage  string
	opt      string
	cost     string
	provider string
}

///////////////////////////////////////////////////////////////////////////////
// OpenStack Functions
///////////////////////////////////////////////////////////////////////////////

func createServer() {
	authOpts := gophercloud.AuthOptions{
		IdentityEndpoint: "http://nebula.ncsa.illinois.edu:5000/v2.0",
		Username:         "you put your username here",
		Password:         "your password to access openstack",
		TenantID:         "find out from your openstack dashboard",
	}
	provider, err := openstack.AuthenticatedClient(authOpts)
	client, err := openstack.NewComputeV2(provider, gophercloud.EndpointOpts{
		Region: "RegionOne",
	})

	kopts := keypairs.CreateOpts{
		Name: "streamc",
	}
	stored_kp, _ := keypairs.Get(client, kopts.Name).Extract()
	if stored_kp == nil {
		fmt.Println("You didn't create a keypair")
	}

	copts := servers.CreateOpts{
		Name:           "h3abionet16sDemo",
		ImageName:      "Ubuntu 16.04",
		FlavorName:     "m1.xlarge", //"m1.medium",
		SecurityGroups: []string{"default"},
		//UserData:       userdata,
		//Networks:       []servers.Network{{UUID: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"}},
	}

	coptsext := keypairs.CreateOptsExt{
		copts,
		kopts.Name,
	}

	server, err := servers.Create(client, coptsext).Extract()
	if err != nil {
		fmt.Println(err)
		return
	}
	sid := server.ID
	err = servers.WaitForStatus(client, sid, "ACTIVE", 60)
	if err != nil {
		fmt.Println(err)
		return
	}

	server, err = servers.Get(client, sid).Extract()
	if err != nil {
		fmt.Println(err)
		return
	}
	//fmt.Println(server)

    associateOpts := floatingip.AssociateOpts{
        ServerID:   sid,
        FloatingIP: PublicIP,
    }

    err = floatingip.AssociateInstance(client, associateOpts).ExtractErr()
	if err != nil {
		fmt.Println(err)
		return
	}
    //floatingIp, err := floatingip.Get(client, fip.ID).Extract()
}

func listServers() {
	authOpts := gophercloud.AuthOptions{
		IdentityEndpoint: "http://nebula.ncsa.illinois.edu:5000/v2.0",
		Username:         "you put your username here",
		Password:         "your password to access openstack",
		TenantID:         "find out from your openstack dashboard",
	}

	provider, err := openstack.AuthenticatedClient(authOpts)

	client, err := openstack.NewComputeV2(provider, gophercloud.EndpointOpts{
		Region: "RegionOne",
	})

	opts := servers.ListOpts{}

	pager := servers.List(client, opts)

	if err != nil {
		panic(err)
	}

	table := tablewriter.NewWriter(os.Stdout)
	table.SetHeader([]string{"Instance Name", "Status", "Created", "Public IP"})

	pager.EachPage(func(page pagination.Page) (bool, error) {
		serverList, err := servers.ExtractServers(page)
		if err != nil {
			return false, err
		}

		for _, s := range serverList {

			var addr string
			for _, networkAddresses := range s.Addresses {
				elements, ok := networkAddresses.([]interface{})
				if !ok {
					fmt.Printf(
						"[ERROR] Unknown return type for address field: %#v",
						networkAddresses)
					continue
				}

				for _, element := range elements {
					address := element.(map[string]interface{})
					if address["OS-EXT-IPS:type"] == "floating" {
						addr = address["addr"].(string)
					} else {
						if address["version"].(float64) == 4 {
							addr = address["addr"].(string)
						}
					}
					if addr != "" {
						//fmt.Println(addr)
					}
				}
			}

			//connect := "ssh -i streamc.pem ubuntu@" + addr
			connect := addr
			table.Append([]string{
				s.Name,
				s.Status,
				s.Created,
				connect,
			})

		}

		return true, nil
	})

	table.Render()
}

func terminateServers() {
	authOpts := gophercloud.AuthOptions{
		IdentityEndpoint: "http://nebula.ncsa.illinois.edu:5000/v2.0",
		Username:         "you put your username here",
		Password:         "your password to access openstack",
		TenantID:         "find out from your openstack dashboard",
	}

	provider, err := openstack.AuthenticatedClient(authOpts)

	client, err := openstack.NewComputeV2(provider, gophercloud.EndpointOpts{
		Region: "RegionOne",
	})
	sid, err := servers.IDFromName(client, "h3abionet16sDemo")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	err = servers.ForceDelete(client, sid).ExtractErr()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func installTools() {
	printLine()
    uploadFiles()

	printLine()
	dest := "ubuntu@" + PublicIP + ":/tmp"
	sshCopy("rdna.sh", dest)

    fmt.Println("Installing all the necessary software and tools ...")
	cmd := "sh /tmp/rdna.sh"
	sshRun(PublicIP, cmd)
	printLine()
}

func uploadFiles() {
	fmt.Println("Please go to http://www.drive5.com/usearch/download.html and download the latest\nUSEARCH into this directory.")
	printLine()
	fmt.Print("Upload USEARCH (USEARCH filename): ")
	var usearch string
	fmt.Scanln(&usearch)
	dest := "ubuntu@" + PublicIP + ":/home/ubuntu"
	sshCopy(usearch, dest)
}

///////////////////////////////////////////////////////////////////////////////
// Workflow
///////////////////////////////////////////////////////////////////////////////

func testWorkflow() {
}

func installWorkflow() {
	dest := "ubuntu@" + PublicIP + ":/tmp"
	sshCopy("rdna.sh", dest)

	cmd := "sh /tmp/rdna.sh"
	sshRun(PublicIP, cmd)
}

///////////////////////////////////////////////////////////////////////////////
// SSH Functions
///////////////////////////////////////////////////////////////////////////////

func sshRun(ip string, cmd string) {
	privateKey, err := ioutil.ReadFile("streamc.pem")
	signer, _ := ssh.ParsePrivateKey([]byte(privateKey))
	sshConfig := &ssh.ClientConfig{
		User: "ubuntu",
		Auth: []ssh.AuthMethod{
			ssh.PublicKeys(signer),
		},
	}
	host := ip + ":22"
	connection, err := ssh.Dial("tcp", host, sshConfig)
	if err != nil {
		fmt.Errorf("Failed to dial: %s", err)
	}

	session, err := connection.NewSession()
	if err != nil {
		fmt.Errorf("Failed to create session: %s", err)
	}

	var b bytes.Buffer
	session.Stdout = &b
	if err := session.Run(cmd); err != nil {
		panic("Failed to run: " + err.Error())
	}
	//fmt.Println(b.String())
}

func sshCopy(src string, dst string) {
	cmd := "scp"
	args := []string{"-o", "UserKnownHostsFile=/dev/null", "-o", "StrictHostKeyChecking=no", "-i", "streamc.pem", src, dst}
	if err := exec.Command(cmd, args...).Run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

///////////////////////////////////////////////////////////////////////////////
// List Cloud Providers
///////////////////////////////////////////////////////////////////////////////

func listProviders() {
	f, _ := os.Open("provider.csv")
	r := csv.NewReader(f)
	lines, err := r.ReadAll()
	if err != nil {
		fmt.Println("Error reading all lines: %v", err)
	}
	plans := make([]Plan, len(lines))
	for i := 1; i < len(lines); i++ { // skip the header
		line := lines[i]
		plan := Plan{
			name:     line[0],
			vcpu:     line[1],
			ram:      line[2],
			storage:  line[3],
			opt:      line[4],
			cost:     line[6],
			provider: line[8],
		}
		plans[i-1] = plan
	}

	table := tablewriter.NewWriter(os.Stdout)
	table.SetHeader([]string{"NAME", "VCPU", "RAM", "STORAGE", "I/O", "HOURLY COST", "PROVIDER"})
	for i := 0; i < len(plans)-1; i++ {
		table.Append([]string{
			plans[i].name,
			plans[i].vcpu,
			plans[i].ram,
			plans[i].storage,
			plans[i].opt,
			plans[i].cost,
			plans[i].provider,
		})
	}
	table.Render()
}

///////////////////////////////////////////////////////////////////////////////
// Utilities
///////////////////////////////////////////////////////////////////////////////

func sendMail(to string, title string, body string) {
	from := "yourname@gmail.com"
	pass := "i have know idea"

	msg := "From: " + from + "\n" +
		"To: " + to + "\n" +
		"Subject: " + title + "\n" +
		body

	err := smtp.SendMail("smtp.gmail.com:587",
		smtp.PlainAuth("", from, pass, "smtp.gmail.com"),
		from, []string{to}, []byte(msg))

	if err != nil {
		fmt.Println("smtp error: %s", err)
		return
	}
}

func printLine() {
	fmt.Printf("-------------------------------------------------------------------------------\n")
}

///////////////////////////////////////////////////////////////////////////////
// Main
///////////////////////////////////////////////////////////////////////////////

func main() {
	if len(os.Args) < 2 {
		fmt.Println("usage: rdna server|workflow")
		return
	} else if len(os.Args) == 2 {
		if os.Args[1] == "server" {
			fmt.Println("usage: rdna server create|list|terminate|install")
		} else if os.Args[1] == "workflow" {
			fmt.Println("usage: rdna workflow install|run")
		} else {
			fmt.Println("usage: rdna server|workflow")
		}
		return
	} else if len(os.Args) == 3 {
		switch os.Args[1] {
		case "server":
			if os.Args[2] == "provider" {
				listProviders()
			} else if os.Args[2] == "create" {
				createServer()
			} else if os.Args[2] == "list" {
				listServers()
			} else if os.Args[2] == "terminate" {
				terminateServers()
			} else if os.Args[2] == "install" {
				installTools()
			}
		case "workflow":
			if os.Args[2] == "install" {
				installWorkflow()
			} else if os.Args[2] == "test" {
				testWorkflow()
			}
		default:
			fmt.Printf("%q is not valid option.\n", os.Args[1])
			os.Exit(2)
		}
	}
}
