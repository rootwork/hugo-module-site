module hugo-module-site

go 1.17

// For local theme development, you can use replace directives to change the
// location of a loaded module. For instance, to change the location of the
// rootwork/hugo-clarity module, uncomment the next section and change the local
// path to a valid directory relative to this file. Then run `hugo mod get` on
// the command line. More info:
// https://github.com/rootwork/hugo-module-site#local-theme-development

// replace github.com/rootwork/hugo-clarity => ../../temp-proj/clarity_develop

require (
	github.com/chipzoller/hugo-clarity v0.0.0-20220222000918-17e6574dd5c9 // indirect
	github.com/rootwork/hugo-clarity v0.0.0-20220222000918-17e6574dd5c9 // indirect
)
