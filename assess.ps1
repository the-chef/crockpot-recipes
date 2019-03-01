param($confidence = .6, $wager = 10, $year = 2018)
$shit = invoke-webrequest -uri https://raw.githubusercontent.com/the-chef/crockpot-recipes/master/data2018.json
$odds = invoke-webrequest -uri https://raw.githubusercontent.com/the-chef/crockpot-recipes/master/odds2018.csv
$odds.content | Out-File $env:temp\odds.csv
$odds = Import-Csv $env:temp\odds.csv
$json = $shit.content
$global:correct = 0
$global:incorrect = 0
$global:winnings = 0
$global:losses = 0
foreach ($game in $json.games)
{
$date = get-date $game.datetime -Format Mdd

if ($game.prob1 -gt $game.prob2 -and $game.score1 -gt $game.score2 -and $game.prob1 -gt $confidence) {
	Write-host 538 correctly chose $game.score1 $game.team1 $game.prob1 to beat $game.score2 $game.team2 $game.prob2 on $date
	$global:correct++
	foreach ($odd in $odds) {
		if ($odd.team -eq $game.team1 -and $odd.date -eq $date) {
			write-host Money line was $odd.open}}
		$global:winnings = (-1 * $wager / ($odd.open/100)) + $global:winnings
		write-host Winnings: $global:winnings}

elseif ($game.prob1 -lt $game.prob2 -and $game.score1 -lt $game.score2 -and $game.prob2 -gt $confidence) {
	Write-host 538 correctly chose $game.score2 $game.team2 $game.prob2 to beat $game.score1 $game.team1 $game.prob1 on $date
	$global:correct++
	foreach ($odd in $odds) {
		if ($odd.team -eq $game.team2 -and $odd.date -eq $date) {
			write-host Money line was $odd.open}}
		$global:winnings = (-1 * $wager / ($odd.open/100)) + $global:winnings
		write-host Winnings: $global:winnings}

if ($game.prob1 -gt $game.prob2 -and $game.score1 -lt $game.score2 -and $game.prob1 -gt $confidence) {
	Write-host 538 incorrectly chose $game.score1 $game.team1 $game.prob1 to beat $game.score2 $game.team2 $game.prob2 on $date
	$global:incorrect++
	foreach ($odd in $odds) {
		if ($odd.team -eq $game.team1 -and $odd.date -eq $date) {
			write-host Money line was $odd.open}}
		$global:losses = ($global:losses-$wager)
		write-host Losses: $global:losses}

elseif ($game.prob1 -lt $game.prob2 -and $game.score1 -gt $game.score2 -and $game.prob2 -gt $confidence) {
	Write-host 538 incorrectly chose $game.score2 $game.team2 $game.prob2 to beat $game.score1 $game.team1 $game.prob1 on $date
	$global:incorrect++
	foreach ($odd in $odds) {if ($odd.team -eq $game.team2 -and $odd.date -eq $date) {
		write-host Money line was $odd.open}}
	$global:losses = ($global:losses-$wager)
	write-host Losses: $global:losses}

}
$total = ($correct + $incorrect)
Write-host $total games played
Write-host $correct guessed correctly
Write-host $incorrect guessed incorrectly
$percentage = ($correct / $total)
Write-host Confidence of $confidence.tostring("P") resulted in correct predictions $percentage.tostring("P") of the time
$themoney = ($winnings + $losses)
Write-host With a static wager of $wager the return is $themoney
