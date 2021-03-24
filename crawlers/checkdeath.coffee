fs = require "fs"
_=require 'lodash'

dates = [20201130, 20201201, 20201203, 20201207, 20201208, 20201209, 20201211,
20201213, 20201214, 20201215, 20201216, 20201217, 20201218, 20210106, 20210112,
20210114, 20210115, 20210118, 20210119, 20210120, 20210121, 20210122, 20210126,
20210127, 20210128, 20210129, 20210201, 20210202, 20210203, 20210204, 20210205,
20210206, 20210208, 20210209, 20210210, 20210211, 20210212, 20210213, 20210214,
20210215, 20210216, 20210217, 20210218, 20210219, 20210220, 20210221, 20210222,
20210223, 20210224, 20210225, 20210226, 20210227, 20210228, 20210301, 20210302,
20210303, 20210304, 20210305, 20210306, 20210307, 20210308, 20210309, 20210310,
20210311, 20210312, 20210313, 20210314, 20210315, 20210316, 20210317, 20210318,
20210319, 20210320, 20210321, 20210322]

dates = _.reverse dates.sort()
files = {}
dates.forEach (date) ->
  files[date] = require("../files/cryptos-#{date}.json").data

cryptos=require "../cryptos"
# current=require("../files/cryptos-20210322.json").data
# request = ""
novolObserved = ""
novolObservedN = 0
novolDead = ""
novolDeadN = 0
dead = ""
deadN = 0
cyclic = ""
cyclicN = 0
notDead = ""
notDeadN = 0

_.forEach (_.clone cryptos), (crypto) ->
  if "Dead" in crypto.tags
    death = undefined
    typeCyclic = false
    founded = false
    observed = false
    for date in dates
      found = _.find files[date], {"slug": "#{crypto.url.replace("/currencies/","")}"}
      if found?
        founded = true
        if date is 20210322 and found.quote.USD.volume_24h != 0
          observed = true

      if not death? and found and found.quote.USD.volume_24h != 0
        death = date
      else if death? and found and found.quote.USD.volume_24h == 0
        typeCyclic = true

    if not founded
      console.error crypto.name, "NOT FOUND"
      console.error "ERREUR"
      process.exit(1)
      delete cryptos[crypto.name]
    else
      # if crypto.name is "Hemelios"
      #   console.log death, observed, typeCyclic
      #   process.exit(1)
      unless death
        if observed
          # console.error crypto.name, "novol", "observed"
          novolObservedN++
          novolObserved+="name.keyword:\"#{crypto.name}\" or \n"
        else
          # console.error crypto.name, "novol", "dead"
          novolDeadN++
          novolDead+="name.keyword:\"#{crypto.name}\" or \n"
      else
        if typeCyclic
          # console.error crypto.name, death, "cyclique"
          cyclicN++
          cyclic+="name.keyword:\"#{crypto.name}\" or \n"
        else
          # console.error crypto.name, death
          if not observed
            deadN++
            dead+="name.keyword:\"#{crypto.name}\" or \n"
          else
            notDeadN++
            notDead+="name.keyword:\"#{crypto.name}\" or \n"

#
#         # console.log "dead",crypto.name, found.quote.USD.price
#         if found.quote.USD.price < 0.1
#           request+="name.keyword:\"#{crypto.name}\" or "
console.log "Not Dead #{notDeadN}"
console.log notDead.substring(0, notDead.length - (" or ".length))
console.log "Dead #{deadN}"
console.log dead.substring(0, dead.length - (" or ".length))
console.log "Cyclic #{cyclicN}"
console.log cyclic.substring(0, cyclic.length - (" or ".length))
console.log "NovolDead #{novolDeadN}"
console.log novolDead.substring(0, novolDead.length - (" or ".length))
console.log "NovolObserved #{novolObservedN}"
console.log novolObserved.substring(0, novolObserved.length - (" or ".length))

# console.log JSON.stringify cryptos, null, 2
process.exit(1)
# console.log request.substring(0, request.length - (" or ".length))
    # nbDeaths = 0
    # unless crypto.deaths? and crypto.url?
    #   console.log "no deaths", JSON.stringify crypto, null, 2
    #   process.exit(1)
    # unless "01011970" in crypto.deaths
    #   crypto.deaths.forEach (date) ->
    #     unless files[date]?
    #       files[date] = require("../files/cryptos-#{date}.json").data
    #     found = _.find files[date], {"slug": "#{crypto.url.replace("/currencies/","")}"}
    #     unless found
    #       console.log "no found", date, JSON.stringify crypto, null, 2
    #       process.exit(1)
    #     if found.quote.USD.volume_24h != 0
    #       nbDeaths++
    #
    #   if nbDeaths is crypto.deaths.length
    #     delete crypto.deaths
    #     crypto.tags = _.without crypto.tags, "Dead"



request=""

liste.forEach (elem) ->
  found = _.find (_.values cryptos), {"url": "#{elem}"}
  # unless found?
  #   console.log 'error'
  #   process.exit(1)
  # if found? and (not found.deaths? or not "20210309" in found.deaths) #and not ("Dead" in found.tags)
  if found? and "Dead" in found.tags
    request+="name.keyword:\"#{found.name}\" or "


console.log request.substring(0, request.length - (" or ".length))
