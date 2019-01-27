## CodeSnippets-Swift  
![license](https://img.shields.io/badge/licencja-MIT-green.svg)
<a title="Tap for English version" href="README-en.md" alt="British flag">
        <img align="right" src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Flag_of_the_United_Kingdom.svg/28px-Flag_of_the_United_Kingdom.svg.png" /></a>


***CodeSnippets*** - w *xcode* są to fragmenty tekstu używane przez funkcję automatycznego uzupełniania, które *xcode* podpowiada, gdy w edytorze zaczniemy wpisywać znany mu ciąg znaków. Jeśli już używałeś *Xcode* na pewno miałeś z nimi do czynienia zdając sobie z tego sprawę bądź nie.

Poniżej fragment widoku edytora podczas wpisywania słowa `var`. Widać okno z listą podpowiedzi, z której za pomocą strzałek na klawiaturze i przycisku `return` można wybrać snippet:

![autocompletion](assets/var_autocomplition_popup.png)

Widok po wybraniu pierwszego podpowiadanego snippeta, w tym przypadku jest on jednym z wielu zdefiniowanych od nowości w *xcode*:

![autocompleted](assets/var_autocomplited.png)

Na powyższym zdjęciu widać dwa placeholdery<sup id="a_placeholder">[1](#f_placeholder)</sup>: `name` i `value`, które należy zastąpić odpowiednio nazwą zmiennej i jej wartością początkową.

## Organizacja
Snippety<sup id="a_snippet">[2](#f_snippet)</sup> w tym repozytorium podzielone są na kategorie, nazwa kategorii jest też przedrostkiem skrótu<sup id="a_shortcut">[3](#f_shortcut)</sup> snippeta i nazwy pliku.

- `usr` - zwykłe fragmenty
- `inline` - proste wyrażenia, bądź obliczenia
- `func` - implementacja pojedynczej funkcji
- `classBody` - implementacja części powiązanych ze sobą metod i właściwości klasy

- `rx` - fragmenty wspierające programowanie przy użyciu RxSwift
- `rlm` - fragmenty wspierające używanie biblioteki RealmSwift

- `impl` - teksty całych implementacji class, struktur, itd. (elementy bazy kodu)
- `ext` - teksty całych plików implementacji rozszerzeń

	Wrzucam całe implementacje różnych rozwiązań jako snippety, ponieważ pisząc nowy projekt nie zawsze mam dostęp do projektów, które pisałem wcześniej czy do mojego projektu bazowego, natomiast snippety wystarczy zrobić *commit* na github, po tym jak dodam nowy po czym zrobić *checkout* (bądź sklonować, jeśli jeszcze tego nie zrobiłem do __katalogu ze snippetami xcode__<sup id="a_snippet">[4](#f_snippet)</sup> na innym komputerze) i wszystkie fragmenty kodu mam dostępne od razu. Przy czym należy pamiętać, że jeśli edytuje plik snippet’u, gdy aplikacja *xcode* jest uruchomiona konieczny jest jej restart, żeby wczytała je na nowo.
	
- `doc` - dokumentacja kodu, komentarze służące do dokumentowania kodu
- `example` - przykłady, najczęściej przykłady implementacji jakiś rozwiązań nie będące ich szablonami

- `mark` - wstawiają komentarze `// MARK: - <#nazwa etykiety#>
- `mit` - teksty i nagłówki dotyczące licencji MIT

- brak przedrostka - mogą się zdarzyć fragmenty bez przedrostka, najczęściej bardzo krótki, często używane o bardzo skrótowych skrótach, które trzeba po prostu znać, by ich szybko użyć.

> UWAGA: Jeśli używamy wymienionych przedrostków, ich wielkość znaków powinna być zachowana, a jeśli używamy więcej niż jednego powinny być oddzielone za pomocą myślnika `-` zarówno od siebie nawzajem jak i od właściwej nazwy snippetu. Nazwa snippetu powinna natomiast być napisana w stylu `PascalCase` czyli `KazdaPierwszaLieteraSlowaDuza`. Przykład: `rx-func-SetupReactiveX`


### Lista
Lista snippet’ów dostępna jest [tutaj](ListOfSnippets.md) i jest generowana automatycznie przez mały program `fix_snippet_file_name`.

Aby więc uaktualnić listę bądź poprawić i ujednolicić nazwy plików po dodaniu nowego snippetu, nie trzeba edytować wszystkiego ręcznie, wystarczy uruchomić wspomniany program (najlepiej, jeśli ma on ikonkę terminala, klikając na niego, jeśli nie ma trzeba uruchomić go z terminala)

Głównym zadaniem owego programu jest jednak:

- poprawianie skrótów tak by były spójne z przyjętą konwencją;
- zmiana nazw plików by brzmiały tak samo jak skróty, co ułatwia ich rozpoznanie.

	Domyślna nazwa pliku nadawana przez xcode jest taka sama jak wartość identyfikatora danego snippet’u tudzież bardzo nieczytelna
	
> Kod programu `fix_snippet_file_name` jest dostępny na GitHub ([tutaj]()), jest on napisany w *Swift* i można go sobie dowolnie modyfikować, należy pamiętać tylko że po zbudowaniu, *Xcode* sam skopuje go do katalogu ze snippet’ami podmieniając istniejącą wersję (skrypt *"Copy built file to snippets dir"* w zakładce *"Build Phases"* w ustawieniach projektu dla targetu o "zaskakującej" nazwie *`fix_snippet_file_name`*)

## Licencja
Użyłem tu licencji MIT, ale tylko z przyczyn czysto formalnych i jasności intencji, gdyż publikuje fragmenty kodu. Dlatego dla większych fragmentów kodu, jeśli takie się tu znajdują a nie zawierają licencji ma zastosowanie licencja MIT

Jednak prawda jest taka, że gdy fragmenty te są bardzo małe albo nie superinnowacyjne prawa autorskie i tak nie mają zastosowania wiec... Natomiast *Attribution* w przypadku MIT jest wymagane jeśli byście publikowali w całości bądź zmieniony kod, natomiast jeśli używacie jakiegoś skrawka w postaci snippetu lub ze snippetu... nie popadajmy w skrajności, a skompilowanego kodu i tak nikt nie sprawdzi.

---

<sup id="f_placeholder">1.</sup> ***Placeholder***, czyli *symbol zastępczy*, jest to określony tekst (ciąg znaków), który aplikacja zna i jest w stanie znaleźć jego wystąpienia w większym tekście a następnie zastąpić je przypisanymi wartościami.  *Placeholderem* nazywa się też szary tekst wyświetlany w polu tekstowym (UITextField) gdy pole jest puste, najczęściej będący wskazówką co w to pole powinno zostać wpisane. [↩](#a_placeholder)

<sup id="f_snippet">2.</sup> ***Snippet*** czyli *skrawek*, fragment, w tym przypadku fragment kodu albo po prostu tekstu, ponieważ nie musi on być kodem. Snippety to też coś w rodzaju template'ów<sup id="a_template">[5](#f_template)</sup>, gdyż mają placeholdery, które sugerują, że powinny być zastąpione konkretną nazwą, np. nazwą klasy [↩](#a_snippet)

<sup id="f_shortcut">3.</sup> ***Shortcut***, czyli skrót, w przypadku snippetu jest to tekst który należy zacząć wpisywać by xcode podpowiedział/zasugerował nam użycie tego snippeta [↩](#a_shortcut)

<sup id="a_snippet">[4](#f_snippet)</sup> ***Katalog 'CodeSnippets' xcode*** (_~/Library/Developer/Xcode/UserData/CodeSnippets_), czyli katalog, w którym przechowywane są pliki snippet’ów zdefiniowanych przez użytkownika w xcode.

Tylda (~) oznacza twój katalog domowy, czyli pełna ścieżka de facto wygląda tak:
_/Users/[nazwa_wojego_konta]/Library/Developer/Xcode/UserData/CodeSnippets_

W katalogu tym znajdują się pliki typu _plist_ ale z rozszerzeniem _.codesnippet_. Do tego katalogu możesz zrobić _chechkout_ swojego repozytorium ze swoimi snippet’ami, tam też znajdziesz te już zdefiniowane przez Ciebie wcześniej.

<sup id="f_template">5.</sup> ***Template***, czyli *szablon* [↩](#a_template)