# Makefile for generating EPubs from a Jekyll dir

# Configuration: change these variables
TITLE = your title here
AUTHOR = your name here

EPUB_FILENAME = title.epub

LICENSE = Creative Commons Non-Commercial Share Alike 3.0
LANGUAGE = en-us

# path to markdown files (default: current directory)
MD_PATH = .
MD_EXT = md

# Paths to chapters, in order, separated by spaces. Should be all on one line;
# if the line becomes too long, you may continue a line by putting a backslash
# at the end of the line. Paths are relative to MD_PATH.
MD_FILES = article1.md article2.md article3.md article4.md article5.md \
		   article6.md article7.md article8.md article9.md article10.md

# paths to programs/files
PANDOC = pandoc

# folder where to put the generated files
EPUB_FOLDER = _epub

TITLE_PAGE_FILE = title.md
METADATA_FILE = $(EPUB_FOLDER)/metadata.xml

EPUB_MD_PREREQS = $(addprefix $(EPUB_FOLDER)/, $(MD_FILES))

.PHONY: epub
epub: $(EPUB_FILENAME)

.PHONY: title
title: $(TITLE_PAGE_FILE)

.PHONY: metadata
metadata: $(METADATA_FILE)

$(EPUB_FOLDER):
	mkdir -p $@

$(TITLE_PAGE_FILE):
	echo "% $(AUTHOR)" > $@
	echo "% $(TITLE)" >> $@
	echo '' >> $@

$(METADATA_FILE): | $(EPUB_FOLDER)
	echo "<dc:rights>$(LICENSE)</dc:rights>" > $@
	echo "<dc:language>$(LANGUAGE)</dc:language>" >> $@
	echo '' >> $@

$(EPUB_FILENAME): $(TITLE_PAGE_FILE) $(METADATA_FILE) $(EPUB_MD_PREREQS)
	$(PANDOC) -S --epub-metadata=$(METADATA_FILE) -o $(EPUB_FILENAME) \
		$(TITLE_PAGE_FILE) $(EPUB_MD_PREREQS)

$(EPUB_FOLDER)/%.md: $(MD_PATH)/%.md | $(EPUB_FOLDER)
	cp $< $@
	perl -ni -e 'if($$y){if(/^---$$/){$$y=0;next}s/^layout:.*$$//;\
		s/^title:\s*(.*)$$/# $$1/;s/^author:\s*(.*)$$/**$$1**/;print;} \
		$$y = 1 if /^---$$/;print unless $$y' $@
	perl -p0i -e 's/^\s*//' $@
	echo '' >> $@

