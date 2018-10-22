#!/bin/bash

#echo -e "will create deployment yaml"
namespace=${namespace:-"chouti"}
k8s_storeage=${k8s_storeage:-"."}
image=${image:-""}
container_port=${container_port:-"8080"}
health=${health:-"/health"}
replicas=${replicas:-"1"}
initialDelaySeconds=${initialDelay:-"60"}
periodSeconds=${period:-"5"}
create_date=`date +%Y_%m_%d_%H_%M_%S`
label_name=${label_name:-""}

debug(){
echo
echo -e "namespace: ${namespace}"
echo -e "storeage: ${k8s_storeage}"
echo -e "image: ${image}"
echo -e "container_port: ${container_port}"
echo -e "health: ${health}"
echo -e "replicas: ${replicas}"
echo -e "initialDelaySeconds: ${initialDelaySeconds}"
echo -e "periodSeconds: ${periodSeconds}"
echo
}

help(){
echo -e "\tk8s.deployment.create.sh -ln laben_name -ns namespace -save storeage_k8s_file -i default_image -cp container_port -ha health_api -r replicas -ds initial_delay_seconds -ps period_seconds"
echo -e "\t -ln: label name, not blank"
echo -e "\t -i: k8s deploy image name, not blank"
echo -e "\t -ns: k8s namespace, default 'chouti'"
echo -e "\t -save: out yaml file directory, default current directory"
echo -e "\t -cp: k8s deploy container port, health will used, default '8080'"
echo -e "\t -ha: health check probe live and ready, default '/health'"
echo -e "\t -r: k8s deploy container replicas, defualt 1"
echo -e "\t -ds: health delay check, unit is seconds, default 60"
echo -e "\t -ps: health period check, unit is seconds, default 5"
echo -e "\tsuch as: ./k8s.deployment.create.sh -ln chouti-www -i clibing/tomcat:8.x.x # other value will used default"
}

while getopts "ln:ns:save:i:cp:ha:r:ds:ps:" OPT; do
    case $OPT in
        ln)
            label_name=$OPTARG;;
        ns)
            namespace=$OPTARG;;
        save)
            storeage=$OPTARG;;
        i)
            image=$OPTARG;;
        cp)
            container_port=$OPTARG;;
        ha)
            health=$OPTARG;;
        r)
            replicas=$OPTARG;;
        ds)
            initialDelaySeconds=$OPTARG;;
        ps)
            periodSeconds =$OPTARG;;
    esac
done

if [ -z ${label_name} ]; then
    echo -e "label_name is empty"
    debug
    help
    exit 1
fi

#if [ -z ${image} ]; then
#    echo -e "default image is empty"
#    exit 1
#fi

create_deploy(){
    label_name=$1
    if [ -z ${label_name} ]; then
        echo -e "label name prefix is empty"
        exit 1
    fi
    deploy_file= ${k8s_storeage}/${label_name}.deploy.yaml
    if [ -e ${deploy_file} ]; then
        rm -rf ${deploy_file} 
    fi
    touch ${deploy_file} 

cat >${deploy_file} <<EOF
# create by shell
# create time: ${create_date} 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${label_name}
  namespace: ${namespace}
  labels:
    app: ${label_name}
spec:
  replicas: ${replicas}
  selector:
    matchLabels:
      app: ${label_name}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: ${label_name}
    spec:
      containers:
      - name: ${label_name}
        image: ${image}
        imagePullPolicy: Always 
        ports:
        - name: ${label_name}
          containerPort: ${container_port}
          readinessProbe:
            httpGet:
              path: ${health}
              port: ${container_port}
            initialDelaySeconds: ${initialDelaySeconds}
            periodSeconds: ${periodSeconds}
          livenessProbe:
            httpGet:
              path: ${health}
              port: ${container_port}
            initialDelaySeconds: ${initialDelaySeconds}
            periodSeconds: ${periodSeconds}
EOF
}

create_deploy
