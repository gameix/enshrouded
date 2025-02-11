# Create a Virtualbox VM

1. Download [UBUNTU-24.04.01 Server ISO](https://releases.ubuntu.com/noble/ubuntu-24.04.1-live-server-amd64.iso)
2. Create VM (do not automatically start the VM after creation is done)
   3. RAM: 8GB
   4. CPU: 4vCORES
   5. HDD 100GB (allocate)
   6. NETWORK: which has internet connection and sam IP like the Host (Port-forwarding, firewall stuff)
   7. 
3. Install UBUNTU
   4. English
   5. Continue WITHOUT Upgrade!
   5. German keyboard
   6. Ubuntu server minimal
   7. DHCP (user muss am router auf dieses andres routen am besten static am router einstellen etc.)
   8. 192.168.178.56 (remove me)
   9. Use entire harddisk (LVM)
   10. Your Name: gix
   11. Hostname: gameix-appliance
   12. Pick Username: gix
   12. Password: gix12!
   13. Skip Ubuntu Pro  NoW
   14. Install ssh
   14. add docker do install
   15. 