Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require('request-promise').defaults
  url: 'https://coinmarketcap.com/'
_ = require 'lodash'

request()
.then (body) ->
  # console.log body
  $ = cheerio.load(body)

  #__next > div > div.Layout-sc-57oli2-0.sAhSO.cmc-body-wrapper > div:nth-child(1) > div > div.rbayaw-0.jFRIev > div > div > div > div > table > tbody > tr > td.rc-table-cell.nameTHeader___1_bKM.forced_name_font_size___3lG3U.rc-table-cell-fix-left.rc-table-cell-fix-left-last > a > div > div > p
  # #__next > div > div.Layout-sc-57oli2-0.sAhSO.cmc-body-wrapper > div:nth-child(1) > div > div.rbayaw-0.jFRIev > div > div > div > div > table > tbody > tr:nth-child(1) > td.rc-table-cell.nameTHeader___1_bKM.forced_name_font_size___3lG3U.rc-table-cell-fix-left.rc-table-cell-fix-left-last > a
  sites = []
  $('div.rbayaw-0.jFRIev > div > div > div > div > table > tbody > tr > td.rc-table-cell.nameTHeader___1_bKM.forced_name_font_size___3lG3U.rc-table-cell-fix-left.rc-table-cell-fix-left-last > a').each () ->
    sites.push $(@).attr('href')

  Promise.each sites, (site) ->
    Promise.resolve()
    .then () ->
      console.log "coucou", site
      # $ = cheerio.load(body)
    .delay(Math.floor(Math.random() * 4000) + 2000)


.then () ->
  # console.warn "#{JSON.stringify catalogue, null, 2}"
  console.warn "fin"
.catch (err) ->
  console.warn 'ERR', err
.finally () ->
  # spawn("sh", ["-c", "killall java"])
  console.warn "Fin"
