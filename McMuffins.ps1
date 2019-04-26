clear-host
$day = (get-date).AddDays(-1)
$day = get-date $day -Format dd
$month = get-date -Format MM
$year = get-date -Format yyyy
[xml]$whatgame = invoke-webrequest -uri http://gdx.mlb.com/components/game/mlb/year_$year/month_$month/day_$day/miniscoreboard.xml
$testgame = $whatgame.games.game.game_data_directory
$game_data_directory = $testgame -match "kcamlb"
if ($game_data_directory.length -lt 1) {write-host "NO GAME YESTERDAY, FATTY!"; break}
[xml]$thing = invoke-webrequest -uri "http://gdx.mlb.com/$game_data_directory/eventLog.xml"
$plays = $thing.game.team | where {$_.name -ne "Kansas City"} | select -ExpandProperty childnodes
$isit = ($plays.description | Select-String "double play")
if ($isit.length -gt 0) {write-host "DOUBLE PLAY! GET DEM BOGO MCMUFFINS!"}
else {write-host "TOO BAD, FATTY! TRY AGAIN TOMORROW!"}
