$McDonalds = "http://nutrition.mcdonalds.com/nutrition1/nutritionfacts.pdf"
$OliveGarden = "https://media.olivegarden.com/en_us/pdf/olive_garden_nutrition.pdf"
$TacoBell = "https://mywisenutrition.files.wordpress.com/2012/08/taco-bell.pdf"
$menu = $McDonalds

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

$Phrases = ([regex]::Matches(($RawTextOutput -replace '[^a-zA-Z\s]','' -split ' ' ), $pattern).Value | Select-Object -Unique) | Where-Object {(($CommonWords+$BoringWords) -NotContains $_)}

$Phrases
$Phrases.count