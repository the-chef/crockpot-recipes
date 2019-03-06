param($confidence = .6, $wager = 10, $year = 2018, $team = "NA", $startdate = "NA", $stopdate = "NA")
$odds = invoke-webrequest -uri https://raw.githubusercontent.com/the-chef/crockpot-recipes/master/2018.csv
$odds.content | Out-File $env:temp\odds.csv
$odds = Import-Csv $env:temp\odds.csv
$global:correct = 0
$global:incorrect = 0
$global:winnings = 0
$global:losses = 0

if ($team -eq "NA") {}
else {
	$odds = ($odds | Where-Object {$_.home -eq $team -or $_.visitor -eq $team})
	}

if ($startdate -eq "NA") {}
else {
	$odds = ($odds | Where-Object {$_.date -gt $startdate})
	}

if ($stopdate -eq "NA") {}
else {
	$odds = ($odds | Where-Object {$_.date -lt $stopdate})
	}

foreach ($game in $odds) {
	#write-host $game.home $game.finalh $game.h538 vs $game.visitor $game.finalv $game.v538
	if ([int]$game.finalh -gt [int]$game.finalv -and $game.H538 -gt $confidence) {
		write-host $game.date 538 correctly chose the home team $game.finalh $game.home $game.H538 to beat $game.finalv $game.visitor $game.V538 on $game.date and the money line was $game.openh
		$payout = (-1 * [int]$wager / ([int]$game.openh/100))
		if ($payout -lt 0) {$payout = ($payout * -1)}
		$global:winnings = $payout + $global:winnings
		write-host Winnings: $global:winnings
		$global:correct++
		}
	elseif ([int]$game.finalv -gt [int]$game.finalh -and $game.V538 -gt $confidence) {
		write-host $game.date 538 correctly chose the visiting team $game.finalv $game.visitor $game.V538 to beat $game.finalh $game.home $game.H538 on $game.date and the money line was $game.openv
		$payout = (-1 * [int]$wager / ([int]$game.openh/100))
		if ($payout -lt 0) {$payout = ($payout * -1)}
		$global:winnings = $payout + $global:winnings
		write-host Winnings: $global:winnings
		$global:correct++
		}
	elseif ($game.v538 -lt $confidence -and $game.h538 -lt $confidence){}
	else  {
		write-host $game.date 538 incorrectly chose the winner of $game.home $game.finalh $game.h538 vs $game.visitor $game.finalv $game.v538
		$global:losses = ($global:losses-$wager)
		write-host Losses: $global:losses
		$global:incorrect++
		}
					}
					
$total = ($correct + $incorrect)
Write-host $total games played
Write-host $correct guessed correctly
Write-host $incorrect guessed incorrectly
$percentage = ($correct / $total)
Write-host Confidence of $confidence.tostring("P") resulted in correct predictions $percentage.tostring("P") of the time
$themoney = ($winnings + $losses)
Write-host With a static wager of $wager the return is $themoney