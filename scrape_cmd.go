package main

import (
	"fmt"
	"os"

	"github.com/PuerkitoBio/goquery"
)

func main() {
	if len(os.Args) == 1 {
		panic("Please pass in a URL as a parameter")
	}
	doc, _ := goquery.NewDocument(os.Args[1])
	doc.Find("pre").Each(func(i int, s *goquery.Selection) {
		fmt.Printf("%s", s.Text())
	})
}
