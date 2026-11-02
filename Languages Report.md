# Languages used in jhkweb

2026-10-21. Covers the files committed at `HEAD` in the eight repos under `C:\repo\jhkweb`, each on the branch it currently has checked out:

| Repo | Branch |
|---|---|
| BuildConfigs | develop |
| Kelly-Revit-Data-Exporter | develop |
| Kelly-Revit | main-v4 |
| Kelly-Revit-Logic | main-v4 |
| Kelly-Windows | main-v2 |
| Kelly-Windows-Data | main-v2 |
| VCS-Database-Content-Schema | develop |
| VCS-Database-General-Schema | develop |

Files that are not in git, such as build output, are not counted. Neither are binaries like `.ai`, `.psd`, `.png`, `.pdf` and `.zip` (about 31 MB in total, mostly Illustrator icon sources), or the InstallShield project (`.ise`). Like GitHub's language bar, the percentages leave out vendored code: the four Obsidian plugins and two themes under `Kelly-Revit/doc/.obsidian` (JavaScript and CSS).

## All repos

| Language | Files | Lines | Bytes | Share |
|---|---:|---:|---:|---:|
| C# | 1,141 | 84,601 | 2,764,437 | 67.0% |
| XAML | 33 | 7,820 | 499,382 | 12.1% |
| T-SQL | 335 | 9,479 | 412,599 | 10.0% |
| Markdown | 76 | 6,486 | 313,608 | 7.6% |
| MSBuild (`.csproj`, `.sqlproj`, `.props`, `.targets`) | 22 | 1,688 | 86,846 | 2.1% |
| XML (`.xml`, `.config`, `.resx`, `.settings`) | 14 | 507 | 24,452 | 0.6% |
| JSON | 16 | 686 | 22,424 | 0.5% |
| *JavaScript (vendored, not counted)* | 4 | 21,488 | 2,356,298 | – |
| *CSS (vendored, not counted)* | 5 | 2,263 | 80,701 | – |

## By repo

| Repo | C# | XAML | T-SQL | Markdown | MSBuild | XML | JSON |
|---|---:|---:|---:|---:|---:|---:|---:|
| Kelly-Revit | 52,064 / 777 | 7,739 / 32 | – | 4,663 / 45 | 385 / 3 | 194 / 5 | 672 / 14 |
| Kelly-Revit-Logic | 13,579 / 110 | – | – | 206 / 12 | 164 / 1 | 278 / 7 | – |
| Kelly-Windows | 11,866 / 161 | 81 / 1 | 123 / 1 | 303 / 4 | 171 / 3 | 27 / 1 | 7 / 1 |
| Kelly-Windows-Data | 5,217 / 75 | – | – | 333 / 4 | 131 / 3 | – | 7 / 1 |
| Kelly-Revit-Data-Exporter | 1,446 / 17 | – | – | 60 / 2 | 43 / 2 | 8 / 1 | – |
| BuildConfigs | 429 / 1 | – | – | 199 / 4 | 157 / 8 | – | – |
| VCS-Database-Content-Schema | – | – | 4,855 / 160 | 600 / 3 | 310 / 1 | – | – |
| VCS-Database-General-Schema | – | – | 4,501 / 174 | 122 / 2 | 327 / 1 | – | – |

Each cell is lines / files.

## Notes

- The v4 checkouts have no Kelly-Domain or Kelly-Revit-UI repo, so those layers are not counted.
- Kelly-Revit also has 3 `.drawio` diagrams, 9 `.ico` files and 3 `.svg` files, which are not counted.
- The only T-SQL outside the two schema repos is one script in Kelly-Windows.
