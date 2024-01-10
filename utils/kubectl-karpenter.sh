#!/bin/bash

eval "$(kubectl get nodes -o json | jq '.items|=sort_by(.metadata.creationTimestamp) | .items[]' | jq -r '[ "printf", "%-50s %-19s %-19s %-1s %-2s %-7s %-15s %s %s %s\n", .metadata.name, (.spec.providerID | split("/")[4]), (.metadata.creationTimestamp | sub("Z";"")), (if ((.status.conditions | map(select(.status == "True"))[0].type) == "Ready") then "✔" else "?" end), (.metadata.labels."topology.kubernetes.io/zone" | split("-")[2]), (.metadata.labels."node.kubernetes.io/instance-type" | sub("arge";"")), (if .metadata.labels."karpenter.k8s.aws/instance-network-bandwidth" then .metadata.labels."karpenter.k8s.aws/instance-cpu"+"核"+(.metadata.labels."karpenter.k8s.aws/instance-memory" | tonumber/1024 | tostring+"G")+(.metadata.labels."karpenter.k8s.aws/instance-network-bandwidth" | tonumber/1000 | tostring+"Gbps") else " *"+.status.capacity.cpu+"核"+"*" end), (.metadata.labels."beta.kubernetes.io/arch" | sub("64";"") | sub("amd";"x86")), (if .metadata.labels."karpenter.sh/capacity-type" == "on-demand" or .metadata.labels."eks.amazonaws.com/capacityType" == "ON_DEMAND" then "按需" else "SPOT" end), (.metadata.labels."karpenter.sh/nodepool" // "*节点组*") ] | @sh')"