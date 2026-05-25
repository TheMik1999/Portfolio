using FileIO
using Images
using ImageIO
using Colors

# ===== FOLDERY =====

input_folder = "images/png/original"
output_folder = "images/png"

isdir(output_folder) || mkdir(output_folder)

# ===== CROP =====

function crop_black(img)

    # próg wykrywania treści
    threshold = 0.05

    h = size(img, 1)
    w = size(img, 2)

    ys = Int[]
    xs = Int[]

    for y in 1:h
        for x in 1:w

            c = img[y, x]

            # ===== JASNOŚĆ PIXELA =====
            brightness = maximum((
                Float64(red(c)),
                Float64(green(c)),
                Float64(blue(c))
            ))

            # ===== ALPHA =====
            alpha_ok = true

            try
                alpha_ok = Float64(alpha(c)) > threshold
            catch
                alpha_ok = true
            end

            # ===== ZAWARTOŚĆ =====
            if brightness > threshold && alpha_ok

                push!(ys, y)
                push!(xs, x)

            end

        end
    end

    # ===== jeśli obraz pusty =====
    if isempty(xs) || isempty(ys)
        return img
    end

    xmin = minimum(xs)
    xmax = maximum(xs)

    ymin = minimum(ys)
    ymax = maximum(ys)

    return img[ymin:ymax, xmin:xmax]

end

# ===== PRZETWARZANIE =====

for file in readdir(input_folder)

    # tylko png
    endswith(lowercase(file), ".png") || continue

    path = joinpath(input_folder, file)

    println("Processing: ", file)

    img = load(path)

    cropped = crop_black(img)

    save(joinpath(output_folder, file), cropped)

end

println("DONE")