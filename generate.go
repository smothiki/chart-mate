package main

import (
	"fmt"
	"os"
	"strings"
	"text/template"
)

type generate struct {
}

type storage struct {
	RegBucket   string
	DataBucket  string
	BuildBucket string
	StorageType string
	Region      string
	Accesskey   string
	Secretkey   string
	Accountname string
	Accountkey  string
	KeyJSON     string
}

func checkError(err error) {
	if err != nil {
		fmt.Println("Fatal error ", err.Error())
		os.Exit(1)
	}
}

func replace(key string) string {
	return strings.Replace(key, "&#34;", "\"", -1)
}
func main() {
	storageObj := storage{
		RegBucket:   os.Getenv("regBucket"),
		DataBucket:  os.Getenv("dataBucket"),
		BuildBucket: os.Getenv("buildBucket"),
		StorageType: os.Getenv("storagebackend"),
		Region:      os.Getenv("region"),
		Accesskey:   os.Getenv("accesskey"),
		Secretkey:   os.Getenv("secretkey"),
		Accountname: os.Getenv("accountname"),
		KeyJSON:     os.Getenv("keyjson"),
	}
	fmt.Println(storageObj)
	// funcs := template.FuncMap{"KeyJSON": html.UnescapeString}
	tpl := os.Args[1]
	t, err := template.ParseFiles(tpl)
	checkError(err)
	genpath := os.Args[2]
	output, err := os.Create(genpath)
	err = t.Execute(output, storageObj)
	checkError(err)
}
