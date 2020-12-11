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

  # echo "Ftx"
  # coffee ./crawlFtx.coffee > tokens.json
  # cp ./tokens.json ../cryptos.json
  #
  # echo "Ftx"
  # coffee ./crawlFtx.coffee > tokens.json
  # cp ./tokens.json ../cryptos.json

  echo "New crypto 1/2"
  coffee ./updateNew2WithCrawl.coffee > tokens.json
  ret=$?
  cp ./tokens.json ../cryptos.json
  if [[ $ret -gt 0 ]]; then
    echo "Fin"
    break
  fi

  echo "New crypto 2/2"
  coffee ./updateNew2WithCrawl.coffee > tokens.json
  ret=$?
  cp ./tokens.json ../cryptos.json
  if [[ $ret -gt 0 ]]; then
    echo "Fin"
    break
  fi

  sleep 60

done
