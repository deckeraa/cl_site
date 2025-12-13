#!/bin/bash

INDEX="index.html"
BOOKS="books.html"
INTERMEDIATE="intermediate.html"

# Check if files exist
if [[ ! -f "$INDEX" ]]; then
    echo "Error: $INDEX not found!"
    exit 1
fi

if [[ ! -f "$BOOKS" ]]; then
    echo "Error: $BOOKS not found!"
    exit 1
fi

# Create a backup first
cp "$INDEX" "${INDEX}.bak"
cp "$INTERMEDIATE" "${INTERMEDIATE}.bak"

# Use awk to replace the section between markers (exclusive), preserving the markers
awk '
NR == FNR {
    books = books $0 "\n"
    next
}
{
    print
}
/<!-- BOOKS_HTML_START -->/ {
    print books
    # Skip lines until we find the END marker
    while (getline > 0) {
        if (/<!-- BOOKS_HTML_END -->/) {
            print
            break
        }
    }
}
' "$BOOKS" "$INDEX" > "${INDEX}.tmp" && mv "${INDEX}.tmp" "$INDEX"

echo "Updated $INDEX with contents of $BOOKS (backup saved as ${INDEX}.bak)"

# Use awk to replace the section between markers (exclusive), preserving the markers
awk '
NR == FNR {
    books = books $0 "\n"
    next
}
{
    print
}
/<!-- BOOKS_HTML_START -->/ {
    print books
    # Skip lines until we find the END marker
    while (getline > 0) {
        if (/<!-- BOOKS_HTML_END -->/) {
            print
            break
        }
    }
}
' "$BOOKS" "$INTERMEDIATE" > "${INTERMEDIATE}.tmp" && mv "${INTERMEDIATE}.tmp" "$INTERMEDIATE"

echo "Updated $INTERMEDIATE with contents of $BOOKS (backup saved as ${INTERMEDIATE}.bak)"
