package main

import (
	"fmt"
	"math/rand"
)

func main() {
	var items []string
	items = append(items, []string{"Pod", "Job", "CronJob", "ReplicaSet", "Deployment"}...)
	items = append(items, []string{"ConfigMap", "Secret", "PersistentVolume", "PersistentVolumeClaim"}...)
	items = append(items, []string{"NodePort", "ClusterIP", "Ingress", "StatefulSet", "HeadlessService"}...)
	items = append(items, []string{"Role", "RoleBinding", "ClusterRole", "ClusterRoleBinding", "NetworkPolicy"}...)

	for len(items) > 0 {
		// Randomly select an index from the slice.
		index := rand.Intn(len(items))

		// Draw and display the element.
		fmt.Println(items[index])

		// Remove the element from the slice.
		items = append(items[:index], items[index+1:]...)
	}
}
