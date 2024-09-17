package main

import (
	"fmt"
	"math/rand"
)

func main() {
	// Example slice of strings
	var elements []string
	elements = append(elements, []string{"Pod", "Job", "CronJob", "ReplicaSet", "Deployment"}...)
	elements = append(elements, []string{"ConfigMap", "Secret", "PersistentVolume", "PersistentVolumeClaim"}...)
	elements = append(elements, []string{"NodePort", "ClusterIP", "Ingress", "StatefulSet", "HeadlessService"}...)
	elements = append(elements, []string{"Role", "RoleBinding", "ClusterRole", "ClusterRoleBinding"}...)
	elements = append(elements, []string{"NetworkPolicy"}...)

	for len(elements) > 0 {
		// Randomly select an index from the slice.
		index := rand.Intn(len(elements))

		// Draw and display the element.
		fmt.Println(elements[index])

		// Remove the element from the slice.
		elements = append(elements[:index], elements[index+1:]...)
	}
}
