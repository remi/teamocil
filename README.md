# Teamocil [![Build Status](https://secure.travis-ci.org/remiprev/teamocil.png?branch=master)](http://travis-ci.org/remiprev/teamocil)

Teamocil is a simple tool used to automatically create sessions, windows and splits in [tmux](http://tmux.sourceforge.net/) with YAML files.

## Usage

```bash
$ gem install teamocil
$ mkdir ~/.teamocil
$ teamocil --edit sample
$ tmux
$ teamocil sample
```

## Options

* `--here` opens the session in the current window, do not create an empty first window.
* `--layout` takes a custom file path to a YAML layout file.
* `--edit` opens the layout file (whether or not `--layout` is used) with `$EDITOR`.
* `--list` lists all available layouts in `./.teamocil` or `$TEAMOCIL_PATH`.
* `--show` show the layout content instead of executing it.

## Layout file structure

A layout file is a single YAML file located in `~/.teamocil` or `$TEAMOCIL_PATH` (eg. `~/.teamocil/my-project.yml`).

### Session

You can wrap your entire layout file in a `session` and Teamocil will rename the current session (so that you can find it more easily when running `tmux list-sessions`) before creating your windows.

#### Keys

* `name` (the name of the session)

#### Example

```yaml
session:
  name: "my-awesome-session"
  windows:
    [windows list]
```

### Windows

If you are not using a top-level `session` key, then the first key of your layout file will be `windows`, an array of window items.

#### Item keys

* `name` (the name that will appear in `tmux` statusbar)
* `root` (the directory in which every split will be created)
* `filters` (a hash of `before` and `after` commands to run for each split)
* `clear` (whether or not to prepend a `clear` command before the `before` filters list)
* `layout` (a layout name or serialized string supported by `tmux`’s `select-layout` command)
* `splits` (an array of split items)
* `options` (a hash of tmux options, see `man tmux` for a list)

#### Example

```yaml
windows:
  - name: "my-first-window"
    clear: true
    options:
      synchronize-panes: true
    root: "~/Projects/foo-www"
    filters:
      before:
        - "echo 'Let’s use ruby-1.9.2 for each split in this window.'"
        - "rvm use 1.9.2"
    splits:
      [splits list]
  - name: "my-second-window"
    root: "~/Projects/foo-api"
    splits:
      [splits list]
  - name: "my-third-window"
    root: "~/Projects/foo-daemons"
    splits:
      [splits list]
```

### Splits

Every window must define an array of splits that will be created within it. A vertical or horizontal split will be created, depending on whether the `width` or `height` parameter is used.

#### Item keys

* `cmd` (the commands to initially execute in the split)
* `width` (the split width, in percentage)
* `height` (the split width, in percentage)
* `target` (the split to set focus on before creating the current one)
* `focus` (the split to set focus on after initializing all the splits for a window)

#### Example

```yaml
windows:
  - name: "my-first-window"
    root: "~/Projects/foo-www"
    filters:
      before: "rvm use 1.9.2"
      after: "echo 'I am done initializing this split.'"
    splits:
      - cmd: "git status"
      - cmd: "bundle exec rails server --port 4000"
        focus: true
        width: 50
      - cmd:
          - "sudo service memcached start"
          - "sudo service mongodb start"
        height: 50
```

## Layout examples

See more example files in the `examples` directory.

### Simple two splits window

#### Content of `~/.teamocil/sample-1.yml`

```yaml
windows:
  - name: "sample-two-splits"
    root: "~/Code/sample/www"
    splits:
      - cmd: ["pwd", "ls -la"]
      - cmd: "rails server --port 3000"
        width: 50
```
        

#### Result of `$ teamocil sample-1`

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

### Four tiled splits window

#### Content of `~/.teamocil/sample-2.yml`

```yaml
windows:
  - name: "sample-four-splits"
    root: "~/Code/sample/www"
    splits:
      - cmd: "pwd"
      - cmd: "pwd"
        width: 50
      - cmd: "pwd"
        height: 50
        target: "bottom-right"
      - cmd: "pwd"
        height: 50
        target: "bottom-left"
```

#### Result of `$ teamocil sample-2`

    .------------------.------------------.
    | (0)              | (1)              |
    |                  |                  |
    |                  |                  |
    |                  |                  |
    |------------------|------------------|
    | (3)              | (2)              |
    |                  |                  |
    |                  |                  |
    |                  |                  |
    '------------------'------------------'

## Extras

### Zsh autocompletion

To get autocompletion when typing `teamocil <Tab>` in a zsh session, add this line to your `~/.zshrc` file:

```zsh
compctl -g '~/.teamocil/*(:t:r)' teamocil
```

### Bash autocompletion

To get autocompletion when typing `teamocil <Tab>` in a bash session, add this line to your `~/.bashrc` file:

```bash
complete -W "$(teamocil --list)" teamocil
```

### ERB support

You can use ERB in your layouts. For example, you can use an environment variable in a layout like so:

```yaml
windows:
  - name: "erb-example"
    root: <%= ENV['MY_PROJECT_ROOT'] %>
    splits:
      - cmd: "pwd"
```

## Todo list

* Making sure the layout is valid before executing it (ie. throw exceptions).
* Add more specs.

## Contributors

Feel free to contribute and submit issues/pull requests [on GitHub](https://github.com/remiprev/teamocil/issues), just like these fine folks did:

* Samuel Garneau ([garno](https://github.com/garno))
* Jimmy Bourassa ([jbourassa](https://github.com/jbourassa))
* Brandon Dimcheff ([bdimcheff](https://github.com/bdimcheff))

Take a look at the `spec` folder before you do, and make sure `bundle exec rake spec` passes after your modifications :)

## License

Teamocil is © 2011-2012 [Rémi Prévost](http://exomel.com) and may be freely distributed under the [MIT license](https://github.com/remiprev/teamocil/blob/master/LICENSE). See the `LICENSE` file.
