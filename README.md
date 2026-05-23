# Portfolio — instrukcja uruchomienia

## Struktura plików

```
portfolio/
├── index.html        ← strona główna z galerią
├── about.html        ← strona „o mnie"
├── contact.html      ← strona kontaktowa
├── css/
│   └── style.css
├── js/
│   └── main.js
└── images/           ← tu wrzucasz swoje grafiki
    ├── praca-1.jpg
    ├── praca-2.jpg
    └── avatar.jpg
```

## Jak dodać nową pracę

W pliku `index.html` skopiuj blok `<article class="card">` i zmień:
- `data-category` na: `logo`, `ilustracja`, `plakat` (lub dodaj własną kategorię)
- `src` obrazka na plik w folderze `images/`
- tytuł i opis w `<h2>` i `<p>`

Żeby nowa kategoria działała w filtrach, dodaj też przycisk w sekcji `.filters`:
```html
<button class="filter-btn" data-filter="twoja-kategoria">twoja kategoria</button>
```

## Jak dodać nową zakładkę

1. Stwórz nowy plik, np. `sklep.html` — wzoruj się na `about.html`
2. Dodaj link do nawigacji w **każdym** pliku HTML:
```html
<li><a href="sklep.html">sklep</a></li>
```

## Jak wrzucić na GitHub Pages (za darmo)

1. Załóż konto na [github.com](https://github.com) jeśli nie masz
2. Utwórz nowe repozytorium (np. `portfolio`)
3. Zaznacz opcję **Add a README file**
4. Wgraj wszystkie pliki (przeciągnij i upuść lub przez `git`)
5. Wejdź w **Settings → Pages**
6. W "Source" wybierz **Deploy from a branch → main → / (root)**
7. Kliknij **Save**
8. Po chwili strona będzie dostępna pod adresem:
   `https://twoja-nazwa.github.io/portfolio/`

## Szybkie dostosowanie

W pliku `css/style.css` zmień zmienne na górze:
```css
:root {
  --black: #111111;   /* kolor tekstu i akcentów */
  --font-serif: 'DM Serif Display', Georgia, serif;  /* czcionka nagłówków */
}
```

W plikach HTML zmień `Jan Kowalski` na swoje imię i nazwisko.
