param($confidence = .6, $wager = 10, $year = 2018)
$odds = Import-Csv c:\opat\odds2018.csv
$countto = (($odds.length - 1 )/ 2)
$global:correct = 0
$global:incorrect = 0
$global:winnings = 0
$global:losses = 0
$global:n = 1

do {
	$game = $odds | Where-Object {$_.gamenum -eq $global:n}
	if ($game[0].538 -gt $confidence -and $game[0].final -gt $game[1].final){
		$global:winnings = (-1 * $wager / ($game.open[0] / 100)) + $global:winnings
		write-host 538 had $game[0].538 confidence that $game[0].team $game[0].final would beat $game[1].team $game[1].final Winnings: $global:winnings
		$global:correct++
																			}																		
	elseif ($game[1].538 -gt $confidence -and $game[1].final -gt $game[0].final){
		$global:winnings = (-1 * $wager / ($game.open[1] / 100)) + $global:winnings
		write-host 538 had $game[1].538 confidence that $game[1].team $game[1].final would beat $game[0].team $game[0].final Winnings: $global:winnings
		$global:correct++
																			}
	elseif 	($game[0].538 -gt $confidence -and $game[0].final -lt $game[1].final) {
			$global:losses = ($global:losses-$wager)
			write-host You Lose! 538 had $game[0].538 confidence that $game[0].team $game[0].final would beat $game[1].team $game[1].final Losses: $global:losses
			}
	elseif 	($game[1].538 -gt $confidence -and $game[1].final -lt $game[0].final) {
			$global:losses = ($global:losses-$wager)
			write-host You Lose! 538 had $game[1].538 confidence that $game[1].team $game[1].final would beat $game[0].team $game[0].final Losses: $global:losses
			}
$global:n++
}
while ($global:n -lt $countto)
$total = ($correct + $incorrect)
Write-host $total games played
Write-host $correct guessed correctly
Write-host $incorrect guessed incorrectly
$percentage = ($correct / $total)
Write-host Confidence of $confidence.tostring("P") resulted in correct predictions $percentage.tostring("P") of the time
$themoney = ($winnings + $losses)
Write-host With a static wager of $wager the return is $themoney