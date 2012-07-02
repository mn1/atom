# commonjs fs module
# http://ringojs.org/api/v0.8/fs/

_ = require 'underscore'
$ = require 'jquery'

module.exports =
  # Make the given path absolute by resolving it against the
  # current working directory.
  absolute: (path) ->
    $native.absolute(path)

  # Return the basename of the given path. That is the path with
  # any leading directory components removed. If specified, also
  # remove a trailing extension.
  base: (path, ext) ->
    base = path.replace(/\/$/, '').split("/").pop()
    if ext then base.replace(RegExp(ext + "$"), "") else base

  # Returns the path of a file's containing directory, albeit the
  # parent directory if the file is a directory. A terminal directory
  # separator is ignored.
  directory: (path) ->
    path.replace(new RegExp("/#{@base(path)}\/?$"), '')

  # Returns true if the file specified by path exists
  exists: (path) ->
    return false unless path?
    $native.exists(path)

  # Returns the extension of a file. The extension of a file is the
  # last dot (excluding any number of initial dots) followed by one or
  # more non-dot characters. Returns an empty string if no valid
  # extension exists.
  extension: (path) ->
    match = @base(path).match(/\.[^\.]+$/)
    if match
      match[0]
    else
      ""

  join: (paths...) ->
    return paths[0] if paths.length == 1
    [first, rest...] = paths
    first.replace(/\/?$/, "/") + @join(rest...)

  # Returns true if the file specified by path exists and is a
  # directory.
  isDirectory: (path) ->
    $native.isDirectory path

  # Returns true if the file specified by path exists and is a
  # regular file.
  isFile: (path) ->
    return false unless path?
    $native.isFile(path)

  # Returns an array with all the names of files contained
  # in the directory path.
  list: (path) ->
    $native.list(path, false)

  listTree: (path) ->
    $native.list(path, true)

  move: (source, target) ->
    $native.move(source, target)

  # Remove a file at the given path. Throws an error if path is not a
  # file or a symbolic link to a file.
  remove: (path) ->
    $native.remove path

  # Open, read, and close a file, returning the file's contents.
  read: (path) ->
    $native.read(path)

  # Open, write, flush, and close a file, writing the given content.
  write: (path, content) ->
    $native.write(path, content)

  makeDirectory: (path) ->
    $native.makeDirectory(path)

  traverseTree: (rootPath, fn) ->
    recurse = null
    prune = -> recurse = false

    for path in @list(rootPath)
      recurse = true
      fn(path, prune)
      @traverseTree(path, fn) if @isDirectory(path) and recurse

  lastModified: (path) ->
    $native.lastModified(path)

  async:
    list: (path) ->
      deferred = $.Deferred()
      $native.asyncList path, false, (subpaths) ->
        deferred.resolve subpaths
      deferred

    listTree: (path) ->
      deferred = $.Deferred()
      $native.asyncList path, true, (subpaths) ->
        deferred.resolve subpaths
      deferred
