

function convert-PDFtoText {
	param(
		[Parameter(Mandatory=$true)][string]$file
	)	
	Add-Type -Path ".\Files\itextsharp.dll"
	$pdf = New-Object iTextSharp.text.pdf.pdfreader -ArgumentList $file
	for ($page = 1; $page -le $pdf.NumberOfPages; $page++){
		$text=[iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($pdf,$page)
		Write-Output $text
	}	
	$pdf.Close()
}