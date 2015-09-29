# Description:
#   Create a release pull request on GitHub via hubot.
#
# Configuration:
#   HUBOT_RELEASE_GITHUB_TOKEN # required
#   HUBOT_RELEASE_HEAD # defaults to "master"
#   HUBOT_RELEASE_BASE # defaults to "release"
#   HUBOT_RELEASE_DEFAULT_OWNER
#   HUBOT_RELEASE_TEMPLATE_PATH
#
# Commands:
#   hubot release <owner>/<repository> - Create or update a release pull request
#
# Author:
#   qckanemoto

release = require 'github-pr-release'
_ = require 'underscore'

config =
  token: process.env.HUBOT_RELEASE_GITHUB_TOKEN
  head: process.env.HUBOT_RELEASE_HEAD or 'master'
  base: process.env.HUBOT_RELEASE_BASE or 'release'
  template: process.env.HUBOT_RELEASE_TEMPLATE_PATH

doRelease = (owner, repo, msg) ->
  msg.send 'Now processing...'
  release(_.extend({owner: owner, repo: repo}, config))
    .then (pr) ->
      msg.send "Created release PR for #{owner}/#{repo}: #{pr.html_url}"
    .catch (err) ->
      msg.send "Error: #{err.message}"

module.exports = (robot) ->
  robot.respond /release +([^ \/]+)\/([^ \/]+) *$/i, (msg) ->
    owner = msg.match[1]
    repo = msg.match[2]
    doRelease owner, repo, msg

  robot.respond /release +([^ \/]+) *$/i, (msg) ->
    owner = process.env.HUBOT_RELEASE_DEFAULT_OWNER
    repo = msg.match[1]
    doRelease owner, repo, msg if owner
