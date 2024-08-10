# Least Privilege Service Account

This scenario simulates a pod using the default service account. You can connect to this pod using SSH:
```bash
ssh pwned@10.10.20.2 -p 30024 # Password: pwned
```

The default Kubernetes service account is really limited so this scenario is just to get use to work from a pod and explore what you can enumerate, an example of how to get the Kubernetes version from the API is provided here:
```bash
curl -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" -k https://10.10.20.2:6443/version
```

## References

- https://kubernetes.io/docs/concepts/overview/kubernetes-api/
- https://cloud.hacktricks.xyz/pentesting-cloud/kubernetes-security/kubernetes-enumeration#enumeration-cheatsheet
