while true; do
  #echo "Tick"
  #coffee ./crawl.coffee > cryptos2.json
  #cp ./cryptos2.json cryptos.json
  ## git add cryptos.json
  #sleep 60

  # echo "Token"
  # coffee ./crawlTokens.coffee > tokens.json
  # cp ./tokens.json cryptos.json
  #
  # echo "Token2"
  # coffee ./crawlTokens.coffee > tokens.json
  # cp ./tokens.json cryptos.json

  #echo "Token3"
  #coffee ./crawlTokens.coffee > tokens.json
  #cp ./tokens.json cryptos.json

  echo "Ftx"
  coffee ./crawlFtx.coffee > tokens.json
  cp ./tokens.json ../cryptos.json

  echo "Ftx"
  coffee ./crawlFtx.coffee > tokens.json
  cp ./tokens.json ../cryptos.json

  sleep 60

done
