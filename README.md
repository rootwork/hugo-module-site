# Hugo module testing site

This repo serves as an example of how to load both themes and content as Hugo
modules, which is the New Modern Way™ to avoid having to do clumsy git submodule
workflows with themes, and also allows you to keep your content in a dedicated
repo.

I use it as a way to quickly test themes.

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

See [`config.toml`](config.toml) for a line-by-line commented guide, or read on.

### Changing the theme

Because we're importing the theme using Hugo modules, **you do not need a
`theme` key in your config file**. To change your theme, update the first
`module.imports` `path` in the config file to a different theme's repository
address. This can be any git repo hosting a Hugo theme.

#### Local theme development

If you're developing locally on the theme you're importing as a module (which
was my original use case) you can use the
[`replacements` mapping feature](https://gohugo.io/hugo-modules/configuration/#module-config-top-level),
either in the config file itself or as an environment variable.

However, I had better success using the
[`replace` directive](https://gohugo.io/hugo-modules/use-modules/#make-and-test-changes-in-a-module)
directly in [`go.mod`](go.mod) instead of replacement mapping in the config file
-- it avoids some issues when modules are nested. Also take a look at
[this walk-through](https://www.staticsiteguru.com/post/module-replace/).

In either case, you'll need to run `hugo mod get` after you set these values and
regenerate the site (don't rely on liveReload). In my testing I generally needed
to run [`hugo mod vendor`](#verifying-whats-being-loaded-and-where) each time I
changed anything in the locally-loaded module. So the command I ended up using
a lot was:

```sh
hugo mod get && hugo mod vendor && hugo server --disableFastRender --gc
```

### Changing the content

The second `module.imports` `path`, and the `module.imports.mounts`
section below it, specifies the source of your content. If you want to use Hugo
normally (without importing content from another repo) simply remove this
section.

#### Can I still use `hugo new` to create a post?

**Sort of.** If you run the command `hugo new foo.md`, for instance, Hugo will
create a _local_ file at `content/foo.md`. When rendering the site, that
local file will then be published to `<baseURL>/foo`. However, while you'll be
able to navigate to that address, the theme may not be aware of the content. In
other words, you'll be able to link to it, but it won't show up automatically in
lists of posts.

In general, it's probably better to decide to either use a separate repo for all
your content, or generate all your content locally.

### Loading other resources into Hugo from modules

You can use modules to
[set mount points](https://gohugo.io/hugo-modules/configuration/#module-config-mounts)
for all of Hugo's base directories: `content`, `static`, `layouts`, `data`,
`assets`, `i18n`, and `archetypes`.

As the comments in [`config.toml`](config.toml) illustrate, you can even have
multiple sources for some of these, such as separate content repos loaded by
language in a multilingual site.

### Updating a module

Modules will be downloaded when you first add them; they won't be automatically
updated. If you want to update them you have
[several options](https://gohugo.io/hugo-modules/use-modules/#update-modules):

- Update all modules: `hugo mod get -u`
- Update all modules recursively: `hugo mod get -u ./...`
- Update a single module: `hugo mod get -u <repo_path>`
- Update a single module to a specific version (tag [must use semver](https://go.dev/doc/modules/version-numbers)): `hugo mod get <repo_path>@<git_tag>`

### Verifying what's being loaded and where

Run `hugo mod vendor` to load all modules (and their recursive dependencies) to
a local `_vendor` folder. As
[Nick at Hugo for Developers](https://www.hugofordevelopers.com/articles/master-hugo-modules-managing-themes-as-modules/)
points out, this is very useful for debugging how modules are being mounted,
especially for "not module ready" Hugo themes.

## Building your own Hugo module site

If you don't want to fork this project, you can create a site with Hugo modules
from scratch. The first resource [listed below](#additional-resources) is a
great walk-through, but the list of commands alone is:

```sh
hugo new site <site_name>
cd <site_name>
hugo mod init <repo_url>
```

Then add the `module` and `module.imports` sections of your Hugo config file,
specifying the module(s) you want to use.

If your Hugo site is in a subdirectory of your repo, be sure to run
`hugo mod init` in the Hugo directory. The `go.mod` and `go.sum` files that get
created need to be at the same level in your directory tree as the location
where you run other `hugo` commands.

## Known issues and bugs

- [#9541](https://github.com/gohugoio/hugo/issues/9541): It doesn't appear to be
  possible to import a module from a specific branch on a repo. For example, none
  of the following work as paths:
  - `<repo>@<branch>` (How Hugo modules reference a tag)
  - `<repo>/tree/<branch>` (GitHub style)
  - `<repo>#<branch>` (npm style)

## Additional resources

- [Master Hugo Modules: Managing Themes as Modules](https://www.hugofordevelopers.com/articles/master-hugo-modules-managing-themes-as-modules/)
- [How to use Hugo Modules](https://geeksocket.in/posts/hugo-modules/)
- [How to add a theme using modules (for beginners)](https://discourse.gohugo.io/t/how-to-add-a-theme-using-modules-for-beginners/20665)
- [Hugo modules for “dummies”](https://discourse.gohugo.io/t/hugo-modules-for-dummies/20758)
- [Hugo Module replacements](https://www.staticsiteguru.com/post/module-replace/)
- [My modular site (by bep)](https://github.com/bep/my-modular-site)
- [Hugo Modules documentation](https://gohugo.io/hugo-modules/)

## License

[MIT](LICENSE)
