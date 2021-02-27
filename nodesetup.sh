#!/usr/bin/bash
set -o pipefail

usage() {
	cat <<-EOF
				usage: $0 [--help|-h] [--iniset|-i ] [--update|-u ] [--httpd|-a] [--git|-g ] [--jenkins|-j ]
				Arguments:-
					-h, --help		show this help message and exit
					-u, --update    updates everything (yum)
					-a, --httpd     intalls apache webserver (httpd) 
					-i, --iniset 	initial setup
					-g, --git       intall & configure git 
					-j, --jenkins	install jenkins
			
			EOF
            exit -1
}

iniset() {

update
sleep 5s 
git
#exit 0

}

update() {

echo "====================================== updating os ======================================"
#epel-release
yum install epel-release -y && sleep 2s
yum install wget -y 
#update
yum update -y 
#Disabling selinux
echo "Disabling selinux"
sestatus
setenforce 0
echo "====================================== updated sleeping for 5s =======================================" 
#exit 0

}

httpd() {

echo "installing httpd webserver"
#httpd
yum install httpd -y && sleep 3s
systemctl start httpd
systemctl enable httpd
#exit 0

}

git() {

echo "installing and configuring git"
yum install git -y  && sleep 3s
git config --global user.name "Suvishesh"
git config --global user.email "marksuvi89@gmail.com"
exit 0

}

jenkins() {

echo "installing httpd and jenkins"
httpd

sudo wget -O /etc/yum.repos.d/jenkins.repo     https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins java-1.8.0-openjdk-devel -y && sleep 3s 
systemctl start jenkins
systemctl enable jenkins
#cat /var/lib/jenkins/secrets/initialAdminPassword
#exit 1

}


main()  {

while getopts "agjuh?" OPT;
do
        case $OPT in
                "i") iniset  ;;
                "u") update ;;
                "g") git ;;
                "j") jenkins ;;
                "a") httpd ;;
                h|?) usage ;;
        esac
done

}

main "$@"
