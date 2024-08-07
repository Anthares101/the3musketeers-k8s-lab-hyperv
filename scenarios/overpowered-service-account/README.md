# Overpowered Service Account

## Context

This scenario simulates a pod using a service account with full privileges over the cluster. You can connect to this pod using ssh:
```bash
ssh pwned@10.10.20.2 -p 30022
```

From here you can start exploring how to abuse this level of access, an example of how to get all the deployments from the K8S api is provided here:
```bash
curl -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" -k https://10.10.20.2:6443/apis/apps/v1/deployments
```

## References

- https://kubernetes.io/docs/concepts/overview/kubernetes-api/
- https://cloud.hacktricks.xyz/pentesting-cloud/kubernetes-security/kubernetes-enumeration#enumeration-cheatsheet
