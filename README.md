# Hugo module testing site

This repo serves as an example of how to load both themes and content as Hugo
modules, which is the New Modern Way™ to avoid having to do clumsy git submodule
workflows with themes, and also allows you to keep your content in a dedicated
repo.

I use it as a way to quickly test themes.

See [`config.toml`](config.toml) for a line-by-line commented guide, or read on.

## Requirements

- [Go must be installed](https://go.dev/dl/) on your local machine.
- Make sure you have a reasonably-recent version of Hugo (`hugo version`).
Modules were introduced in 0.55, but additional module-related commands and
settings have continued to appear up through at least 0.84.2.
- Run `hugo mod help` and make sure you get back something that isn't an error,
which confirms that the first two requirements have been met.

## Usage

`hugo serve`

When testing/changing module imports, it can sometimes be useful to use
`hugo server --disableFastRender --gc` to ensure nothing is being cached.

## Development

### Changing the theme

Because we're importing the theme using Hugo modules, you do not need a `theme`
key in your config file. Simply change the first `[[module.imports]]` `path` in
that file to a different theme's repository address. This can be any valid git
repo, so it does not need to be a "published" Hugo theme.

### Changing the content

The second `[[module.imports]]` `path`, and the `[[module.imports.mounts]]`
section below it, specifies the source of your content. If you want to use Hugo
normally (without importing content from another repo) simply remove this
section.

Note that module-imported content only pulls in items at that address, e.g.
static assets like images, if they are stored outside of the content folder,
will not be included.

#### Can I still use `hugo new` to create a post?

**Sort of.** If you run the command `hugo new foo.md`, for instance, Hugo will
create a _local_ file at `content/foo.md`. When rendering the site, that
local file will then be published to `<baseURL>/foo`. However, while you'll be
able to navigate to that address, the theme may not be aware of the content. In
other words, you'll be able to link to it, but it won't show up automatically in
lists of posts.

In general, it's probably better to decide to either use a separate repo for all
your content, or generate all your content locally.

### Updating a module

Modules will be downloaded when you first add them; they won't be automatically
updated. If you want to update them you have
[several options](https://gohugo.io/hugo-modules/use-modules/#update-modules):

- Update all modules: `hugo mod get -u`
- Update all modules recursively: `hugo mod get -u ./...`
- Update a single module: `hugo mod get -u <repo_path>`
- Update a single module to a specific version: `hugo mod get <repo_path>@<git_tag>`

## Additional resources

- [Master Hugo Modules: Managing Themes as Modules](https://www.hugofordevelopers.com/articles/master-hugo-modules-managing-themes-as-modules/)
- [How to add a theme using modules (for beginners)](https://discourse.gohugo.io/t/how-to-add-a-theme-using-modules-for-beginners/20665)
- [Hugo modules for “dummies”](https://discourse.gohugo.io/t/hugo-modules-for-dummies/20758)
- [My modular site (by bep)](https://github.com/bep/my-modular-site)

## License

[MIT](LICENSE)
