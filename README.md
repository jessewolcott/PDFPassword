# PDFPassword

> Generate memorable passphrases from the most unlikely source on earth: **fast-food nutrition PDFs.**

PDFPassword is a PowerShell tool that downloads a restaurant nutrition document, extracts every word inside it, throws away the boring stuff ("calorie", "sodium", "rounded"...) and the everyday English ("about", "able", "access"...), then stitches three of the survivors together with a symbol and a number to form a passphrase you can actually remember.

```
crispy@Marinara42breadstick
```

Yes, your next password could taste like an Olive Garden entrée.

---

## How it works

1. **Fetch** a PDF from a hard-coded URL (Olive Garden, or Taco Bell nutrition facts).
2. **Extract** the raw text from every page using [iTextSharp](https://github.com/itext/itextsharp).
3. **Tokenize** the text, keeping only words 5–10 characters long.
4. **Filter** out:
   - ~3,000 of the most common English words ([CommonWords.ps1](CommonWords.ps1))
   - ~70 nutrition-doc filler words like *dispensed*, *trademark*, *unrounded* ([BoringWords.ps1](BoringWords.ps1))
5. **Compose** the passphrase:

   ```
   <word1><symbol><word2><00-99><word3>
   ```

   where the symbol is a random pick from `! # $ % & * + , < = > ? @ [ \ ] ^ _`.

The result is something memorable enough to type, weird enough to be hard to guess, and short enough to fit in most password fields.

---

## Quick start

Requires Windows PowerShell (or PowerShell Core on Windows) — `iTextSharp.dll` is a .NET Framework library.

```powershell
git clone https://github.com/<you>/PDFPassword.git
cd PDFPassword
.\PasswordGenerator.ps1
```

Out pops a fresh passphrase on stdout.

### Pick a different menu

Edit the top of [PasswordGenerator.ps1](PasswordGenerator.ps1):

```powershell
$OliveGarden = "https://media.olivegarden.com/en_us/pdf/olive_garden_nutrition.pdf"
$TacoBell    = "https://mywisenutrition.files.wordpress.com/2012/08/taco-bell.pdf"
$menu        = $OliveGarden   # ← swap me
```

Any direct PDF URL works. The weirder the source vocabulary, the more colorful the output.

---

## Repo tour

| Path | What it is |
| --- | --- |
| [PasswordGenerator.ps1](PasswordGenerator.ps1) | The main script. Run this. |
| [PDFFunction.ps1](PDFFunction.ps1) | Standalone `convert-PDFtoText` helper. |
| [CommonWords.ps1](CommonWords.ps1) | ~3,000-word stoplist of everyday English. |
| [BoringWords.ps1](BoringWords.ps1) | Nutrition-doc filler words to strip. |
| [itextsharp.dll](itextsharp.dll) | PDF text extraction engine. |
| [Module/PDFPassword.psm1](Module/PDFPassword.psm1) | Scaffolding for a future proper PowerShell module. |
| [Files/](Files/) | Mirror of the DLL + helper function. |

---

## Roadmap

The [PDFPassword.psm1](Module/PDFPassword.psm1) stub hints at where this is headed — a proper module with:

- `New-PDFPassword` — parameterized passphrase generation
- `Get-PDFPasswordStrength` — entropy estimator
- `Get/Set-PDFPasswordDataSource` — swap the source PDF without editing the script
- `Get/Set-PDFPasswordConfiguration` — tune word length, count, separators, etc.

PRs welcome.

---

## Why?

Because diceware is great, but it always sounds the same. A wordlist built from a Taco Bell menu produces passphrases nobody — human or dictionary attacker — is going to guess. It's also a fun excuse to do PDF parsing in PowerShell.

---

## License

[MIT](LICENSE) © 2023 Jesse
