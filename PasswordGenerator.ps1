$McDonalds = "http://nutrition.mcdonalds.com/nutrition1/nutritionfacts.pdf"
$OliveGarden = "https://media.olivegarden.com/en_us/pdf/olive_garden_nutrition.pdf"
$TacoBell = "https://mywisenutrition.files.wordpress.com/2012/08/taco-bell.pdf"
$menu = $OliveGarden

. .\CommonWords.ps1
. .\BoringWords.ps1
$dllpath = "itextsharp.dll"
Unblock-File -Path $dllpath
Add-Type -Path "$PSScriptRoot\$dllpath"

$pdf = New-Object iTextSharp.text.pdf.pdfreader -ArgumentList $menu

$RawTextOutput = for ($page = 1; $page -le $pdf.NumberOfPages; $page++){
                [iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($pdf,$page)		
	            }	
	$pdf.Close()

$pattern = @"
(\b\w{5,10})?\b
"@

$PhraseBank = @([regex]::Matches(($RawTextOutput -replace '[^a-zA-Z\s]','' -split ' ' ), $pattern).Value | Select-Object -Unique) | Where-Object {(($CommonWords+$BoringWords) -NotContains $_)}

## Password Generator ##
#$PhraseBank = Get-Content .\PhraseBank.txt
[String]$RandomNumber = (Get-Random -Maximum 99)
$PW1       = $PhraseBank | Get-Random -ErrorAction SilentlyContinue
$PW2       = $PhraseBank | Get-Random -ErrorAction SilentlyContinue
$PW3       = $PhraseBank | Get-Random -ErrorAction SilentlyContinue
$SpecialCharacters = (@((0,33,35) + (36..38) + (42..44) + (60..64) + (91..95)) | Get-Random -Count 1 | ForEach-Object {[char]$_})
# https://thesysadminchannel.com/generate-strong-random-passwords-using-powershell/
$PWGeneratedClearText = $PW1+$SpecialCharacters+$PW2+$RandomNumber+$PW3
$PWGenerated = $PWGeneratedClearText | ConvertTo-SecureString -AsPlainText -Force
## Password Generator ##

$PWGeneratedClearText