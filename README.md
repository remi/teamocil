<p align="center">
  <a href="https://github.com/remiprev/teamocil">
    <img src="http://i.imgur.com/NX2eV2X.png" alt="Teamocil" />
  </a>
  <br />
  Teamocil is a simple tool used to automatically create sessions,<br /> windows and panes in <a href="http://tmux.sourceforge.net">tmux</a> with YAML files.
  <br /><br />
  <a href="https://rubygems.org/gems/teamocil"><img src="http://img.shields.io/gem/v/teamocil.svg" /></a>
  <a href="https://travis-ci.org/remiprev/teamocil"><img src="http://img.shields.io/travis/remiprev/teamocil.svg" /></a>
</p>

---

## Installation

```bash
# Install the `teamocil` Ruby gem
$ gem install teamocil

# Create your layout directory
$ mkdir ~/.teamocil

# Edit ~/.teamocil/sample.yml (look for sample layouts in this very `README.md`)
$ teamocil --edit sample

# Launch tmux
$ tmux

# Run your newly-created sample layout
$ teamocil sample
```

## Usage

```bash
$ teamocil [options] [layout-name]
```

### Global options

| Option      | Description
|-------------|----------------------------
| `--list`    | Lists all available layouts in `~/.teamocil` or `$TEAMOCIL_PATH`

### Layout options

| Option      | Description
|-------------|----------------------------
| `--layout`  | Takes a custom file path to a YAML layout file instead of `[layout-name]`
| `--here`    | Uses the current window as the layout’s first window
| `--edit`    | Opens the layout file with `$EDITOR` instead of executing it
| `--show`    | Shows the layout content instead of executing it

## Upgrading

Teamocil 1.0 is a complete rewrite (from scratch!) of teamocil. The code is now
very much simpler, cleaner and easier to maintain.

The downside of that is that several features were dropped during the rewrite
process, mostly because I didn’t actually use/need them and I got tired of
maintaining features I don’t think are useful.

But hey, that’s just my opinion. Feel free to fork the repository and add as
many features as you want :smile:.

## Configuration

### Windows

| Key      | Description
|----------|----------------------------
| `name`   | The tmux window name
| `root`   | The path where all panes in the window will be started
| `layout` | The layout that will be set after all panes are created by teamocil
| `panes`  | An `Array` of panes
| `focus`  | If set to `true`, the window will be selected after the layout has been executed

### Panes

A pane can either be a `String` or a `Hash`. If it’s a `String`, teamocil will
treat it as a single-command pane.

| Key        | Description
|------------|----------------------------
| `commands` | An `Array` of commands that will be ran when the pane is created
| `focus`    | If set to `true`, the pane will be selected after the layout has been executed

## Examples

### Simple two pane window

```yaml
windows:
  - name: sample-two-panes
    root: ~/Code/sample/www
    layout: even-horizontal
    panes:
      - git status
      - rails server
```

```
.------------------.------------------.
| (0)              | (1)              |
|                  |                  |
|                  |                  |
|                  |                  |
|                  |                  |
|                  |                  |
|                  |                  |
|                  |                  |
|                  |                  |
'------------------'------------------'
```

### Simple three pane window

```yaml
windows:
  - name: sample-three-panes
    root: ~/Code/sample/www
    layout: main-vertical
    panes:
      - vim
      - rails server
      - git status
```

```
.------------------.------------------.
| (0)              | (1)              |
|                  |                  |
|                  |                  |
|                  |                  |
|                  |------------------|
|                  | (2)              |
|                  |                  |
|                  |                  |
|                  |                  |
'------------------'------------------'
```

### Simple four pane window

```yaml
windows:
  - name: sample-two-panes
    root: ~/Code/sample/www
    layout: tiled
    panes:
      - vim
      - foreman start web
      - git status
      - foreman start worker
```

```
.------------------.------------------.
| (0)              | (1)              |
|                  |                  |
|                  |                  |
|                  |                  |
|------------------|------------------|
| (2)              | (3)              |
|                  |                  |
|                  |                  |
|                  |                  |
'------------------'------------------'
```

## Contributors

Feel free to contribute and submit issues/pull requests
[on GitHub](https://github.com/remiprev/teamocil/issues), just like these fine
folks did:

* [@garno](https://github.com/garno)
* [@jbourassa](https://github.com/jbourassa)
* [@bdimcheff](https://github.com/bdimcheff)
* [@jscheel](https://github.com/jscheel)
* [@mklappstuhl](https://github.com/mklappstuhl)

## License

Teamocil is © 2011-2014 [Rémi Prévost](http://exomel.com) and may be freely
distributed under the [MIT license](https://github.com/remiprev/teamocil/blob/master/LICENSE.md).
See the `LICENSE.md` file for more information.
