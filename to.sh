IMG_REPO=quay.io/fdeutsch/shs-ws

build() {
  podman -r build -t $IMG_REPO -f Containerfile .
}

push() {
  podman -r push $IMG_REPO
}

i() { echo "i: $@"; }
x() { echo "\$ $@" ; eval "$@" ; }
die() { echo "err: $@" ; exit 1; }
_oc() { echo "$ oc $@" ; oc $@ ; }
qoc() { oc $@ > /dev/null 2>&1; }

apply() {
  _oc apply -f manifests/app.yaml
  sleep 1
  _oc get -o jsonpath="{.status.ingress[0].host}{'\n'}" route ws
}


deploy() {
  local NS=ws
  local SA=$NS
  qoc get project $NS || _oc adm new-project $NS
  _oc project $NS
  qoc get sa -n $NS $SA || {
    _oc create sa -n $NS $SA
    _oc adm policy add-cluster-role-to-user cluster-admin -z $SA
    _oc adm policy add-scc-to-user -n $NS privileged -z $SA
  }
  apply
}

destroy() {
  _oc delete -f manifests/app.yaml
}

server() {
  podman run --name ws-server -ti --rm -p 8888:80 \
    $IMG_REPO /server.sh
}

client() {
  podman run --name ws-client -ti --rm \
    $IMG_REPO /client.sh $@
}

usage() {
  grep -E -o "^.*\(\)" $0
}

eval "${@:-usage}"
