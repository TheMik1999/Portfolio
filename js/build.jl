using Base64
using Images
let 
# ============================================================
# KONFIGURACJA
# ============================================================
IMG_DIR      = joinpath(@__DIR__, "..", "images", "png")
INDEX_IN     = joinpath(@__DIR__, "..", "template", "index_template.html")
INDEX_OUT    = joinpath(@__DIR__, "..", "index.html")
AUTHOR       = "Maciej Doniec"
COPYRIGHT    = "© 2025 Maciej Doniec. All rights reserved."

# ============================================================
# FUNKCJE
# ============================================================
function img_to_base64(path)
    data = read(path)
    return "data:image/png;base64," * base64encode(data)
end

function get_category(path)
    img = load(path)
    h, w = size(img)
    println("$(basename(path)): h=$h w=$w diff=$(abs(h-w)) próg=$(0.1 * max(h,w))")
    return abs(h - w) <= 0.01 * max(h, w) ? "kwadraty" : "czas"
end

function set_exif(path)
    run(`exiftool
        -overwrite_original
        -Author=$AUTHOR
        -Copyright=$COPYRIGHT
        -CopyrightNotice=$COPYRIGHT
        -Creator=$AUTHOR
        $path`)
end
function sort_files(files)
    # wyciąga numer z nazwy typu A1_, A2_, A15_
    function sort_key(f)
        m = match(r"^A(\d+)_", f)
        if m !== nothing
            return (0, parse(Int, m.captures[1]))  # A-pliki pierwsze, po numerze
        else
            return (1, 0)  # reszta po nich, w oryginalnej kolejności
        end
    end
    return sort(files, by=sort_key)
end


# ============================================================
# BUDOWANIE GALERII
# ============================================================
files = sort_files(filter(f -> endswith(f, ".png"), readdir(IMG_DIR)))

if isempty(files)
    error("Brak plików PNG w $IMG_DIR")
end

println("Znaleziono $(length(files)) obrazków...")

local_html = "<div id=\"card-source\" hidden>\n"

for filename in files
    path = joinpath(IMG_DIR, filename)

    print("  → $filename ... ")

    # metadane EXIF
    set_exif(path)

    # kategoria z proporcji
    category = get_category(path)

    # base64
    src = img_to_base64(path)

    local_html *= """
  <article class="card" data-category="$category">
    <div class="card-img-wrap">
      <img src="$src" alt="" loading="lazy" />
    </div>
  </article>\n"""

    println("$category ✓")
end

local_html *= "</div>"

# ============================================================
# WSTAWIANIE DO index.local_html
# ============================================================
template = read(INDEX_IN, String)

marker_start = "<!-- GALLERY Start-->"
marker_end   = "<!-- GALLERY End-->"

if !occursin(marker_start, template) || !occursin(marker_end, template)
    error("Brak znaczników <!-- GALLERY Start--> lub <!-- GALLERY End--> w index_template.html")
end

before = template[1 : first(findfirst(marker_start, template)) - 1]
after  = template[last(findfirst(marker_end, template)) + 1 : end]

output = before * marker_start * "\n" * local_html * marker_end * after
write(INDEX_OUT, output)
end