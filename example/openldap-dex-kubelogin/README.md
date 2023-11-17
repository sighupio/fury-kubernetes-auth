# OpenLDAP + Dex + Kubelogin setup

This example shows how to create the following setup:

- Local KinD cluster with OIDC authentication enabled through Dex

- OpenLDAP installed on Kubernetes

- Dex installed on Kubernetes

After the setup, you will be able to create a kubeconfig for users existing in OpenLDAP.

Before starting, be sure to:

- install [kubectl](https://kubernetes.io/docs/tasks/tools/)

- install [kubelogin](https://github.com/int128/kubelogin)

- install [kind](https://kind.sigs.k8s.io/) and Docker/Podman

## 1. KinD cluster

First of all, we need to create the certificates and spin up a KinD cluster.

```bash
# Target the correct directory
cd kind

# Generate the needed certificates. You will see an ssl folder after you launch the script.
./gencerts.sh

# Bring up the KinD cluster. It has 1 control-plane and 1 worker.
kind create cluster --config kind-config.yml

# Create a secret with the certificates - we will use it later on
kubectl create secret generic dex-ssl --from-file=cert.pem=ssl/cert.pem --from-file=key.pem=ssl/key.pem -n kube-system

# Return to the example directory
cd ..
```

Verify that the nodes are Ready and all the pods are running.

```bash
kubectl get nodes
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   58s   v1.27.1
kind-worker          Ready    <none>          33s   v1.27.1

kubectl get pods -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-5d78c9869d-5x7m7                     1/1     Running   0          2m10s
kube-system          coredns-5d78c9869d-jfc6m                     1/1     Running   0          2m10s
kube-system          etcd-kind-control-plane                      1/1     Running   0          2m21s
kube-system          kindnet-6dlps                                1/1     Running   0          2m1s
kube-system          kindnet-k5smr                                1/1     Running   0          2m10s
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          2m21s
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          2m21s
kube-system          kube-proxy-6gvgh                             1/1     Running   0          2m1s
kube-system          kube-proxy-z72c6                             1/1     Running   0          2m10s
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          2m21s
local-path-storage   local-path-provisioner-6bc4bddd6b-x5nhf      1/1     Running   0          2m10s
```

From the `kube-apiserver` logs you should see some errors related to `oidc authenticator`. 
This is expected, since our Dex server has not been installed yet.

```bash
kubectl logs -n kube-system -l component=kube-apiserver
...
E1117 08:55:06.201331       1 oidc.go:335] oidc authenticator: initializing plugin: Get "https://oidc:31557/dex/.well-known/openid-configuration": EOF
E1117 08:55:11.202164       1 oidc.go:335] oidc authenticator: initializing plugin: Get "https://oidc:31557/dex/.well-known/openid-configuration": EOF
E1117 08:55:21.207783       1 oidc.go:335] oidc authenticator: initializing plugin: Get "https://oidc:31557/dex/.well-known/openid-configuration": EOF
...
```

## 2. OpenLDAP server

```bash
# Target the correct directory
cd openldap

# Deploy OpenLDAP
kubectl apply -f openldap.yml

# Wait for container to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=openldap -n kube-system

# Search for user01 - you should obtain "numEntries: 1"
kubectl exec deploy/openldap -n kube-system -- ldapsearch -x -H ldap://127.0.0.1:1389 -b 'dc=example,dc=org' "(&(objectClass=inetOrgPerson)(uid=user01))"

# Search for user02 - you should obtain "numEntries: 1"
kubectl exec deploy/openldap -n kube-system -- ldapsearch -x -H ldap://127.0.0.1:1389 -b 'dc=example,dc=org' "(&(objectClass=inetOrgPerson)(uid=user02))"

# Search for users group - you should obtain "numEntries: 1"
kubectl exec deploy/openldap -n kube-system -- ldapsearch -x -H ldap://127.0.0.1:1389 -b 'dc=example,dc=org' "(&(objectClass=organizationalUnit)(ou=users))"

# Return to example directory
cd ..
```

## 3 Dex

Now let's bring up Dex server.

```bash
# Target the correct directory
cd dex

# Deploy Dex
kustomize build . | kubectl apply -f -

# Wait for container to be ready
kubectl wait --for=condition=ready pod -l app=dex -n kube-system

# Return to example directory
cd ..
```

## 4 RBAC

Now we need to grant some permissions to `user01`.

Let's apply the content of `rbac.yml`.

```bash
kubectl apply -f rbac/rbac.yml
```

For this example, we are just giving `user01` the permissions to get, watch and list pods in `kube-system` namespace.

No other operation will be possible with this user.

## 5 Login

Now, before proceeding, you need to find your own local IP and put an entry to `/etc/hosts`.

```bash
# Find your IP
ipconfig getifaddr en0
192.x.x.x

echo "192.x.x.x oidc" >> /etc/hosts
```

This DNS resolution will be used by your local kubectl and by KinD's apiserver.

At this point, you should not see errors regarding oidc in kube-apiserver logs anymore.

Let's login!

```bash
kubectl oidc-login setup --oidc-issuer-url=https://oidc:31557/dex --oidc-client-id=kubernetes --oidc-client-secret=kubernetes-dex-secret --certificate-authority=kind/ssl/ca.pem --oidc-extra-scope=email
```

A web page will pop up, asking you to log in through Dex.

Insert credentials `user01,password01`, then click on "Grant access" and come back to your Terminal.

Now set up a local user. Be sure to use a full path in certificate-authority arg.

```bash
kubectl config set-credentials oidc-user01 \
  --exec-api-version=client.authentication.k8s.io/v1beta1 \
  --exec-command=kubectl \
  --exec-arg=oidc-login \
  --exec-arg=get-token \
  --exec-arg=--oidc-issuer-url=https://oidc:31557/dex \
  --exec-arg=--oidc-client-id=kubernetes \
  --exec-arg=--oidc-client-secret=kubernetes-dex-secret \
  --exec-arg=--oidc-extra-scope=email \
  --exec-arg=--certificate-authority=$PWD/kind/ssl/ca.pem

```

As stated before, `user01` cannot perform any operation except get, watch and list pods in `kube-system`, so you cannot get nodes.

```bash
# Try to get the nodes - the first time you do it, the web page will pop up again.
kubectl --user=oidc-user01 get nodes
Error from server (Forbidden): nodes is forbidden: User "oidc:user01" cannot list resource "nodes" in API group "" at the cluster scope

# Try another operation, for example get namespaces
kubectl --user=oidc-user01 get ns
Error from server (Forbidden): namespaces is forbidden: User "oidc:user01" cannot list resource "namespaces" in API group "" at the cluster scope

# Now, this should work
kubectl --user=oidc-user01 get pods -n kube-system

# If you want, you can configure this as the default user
kubectl config set-context --current --user=oidc-user01

```

Finally, a minimal kubeconfig for `user01` will look like the following:

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: XXXX
    server: https://0.0.0.0:XXXX
  name: kind-kind
contexts:
- context:
    cluster: kind-kind
    user: oidc-user01
  name: kind-user01
current-context: kind-user01
kind: Config
preferences: {}
users:
- name: oidc-user01
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - oidc-login
      - get-token
      - --oidc-issuer-url=https://oidc:31557/dex
      - --oidc-client-id=kubernetes
      - --oidc-client-secret=kubernetes-dex-secret
      - --oidc-extra-scope=email
      - --certificate-authority=XXX/kind/ssl/ca.pem
      command: kubectl
      env: null
      interactiveMode: IfAvailable
      provideClusterInfo: false

```