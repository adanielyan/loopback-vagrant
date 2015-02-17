# loopback-vagrant

This Vagrant configuration will help you to setup a VM with LoopBack pre-installed using Vagrant. This configuration also attempts to solve the issue with shared folders on host machine. See https://github.com/strongloop/strongloop/issues/179#issuecomment-71919097 for more details.

To setup the development environment clone this repository, then cd in the folder with Vagrantfile and run ```vagrant up```. The VM creation process may take a while.

Once the vagrant up is finished you will be asked to reboot the VM by running ```vagrant reload``` command. After reloading your VM will be running in the background. Run ```vagrant ssh``` to ssh into your newly created VM. On Windows host you will need the ssh CLI installed to run this command. Alternatevely you can use [puTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html "puTTY") client to ssh into ```localhost:2222```.

If you want to use StronLoop arc run ```PORT=4000 slc arc .``` to run arc on port 4000 that is mapped to the same port on your host. Then you can access your arc web interface in browser on host machine by visiting ```http://localhost:4000``` URL.

