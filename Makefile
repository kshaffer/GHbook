# Makefile for generating EPubs from a Jekyll dir

# Configuration: change these variables
TITLE = your title here
AUTHOR = your name here

# change these if you like; they will default to the title you fill in above
EPUB_FILENAME = $(TITLE).epub
PDF_FILENAME = $(TITLE).pdf

LICENSE = Creative Commons Non-Commercial Share Alike 3.0
LANGUAGE = en-us

# path to markdown files (default: current directory)
MD_PATH = .

# Paths to chapters, in order, separated by spaces. Should be all on one line;
# if the line becomes too long, you may continue a line by putting a backslash
# at the end of the line. Paths are relative to MD_PATH.
MD_FILES = article1.md article2.md article3.md article4.md article5.md \
		   article6.md article7.md article8.md article9.md article10.md

# paths to programs/files
PANDOC = pandoc

# folder where to put the generated files
EPUB_FOLDER = _epub
PDF_FOLDER = _pdf

TITLE_PAGE_FILE = title.md
METADATA_FILE = $(EPUB_FOLDER)/metadata.xml

EPUB_MD_PREREQS = $(addprefix $(EPUB_FOLDER)/, $(MD_FILES))

.PHONY: epub
epub: $(EPUB_FILENAME)

.PHONY: title
title: $(TITLE_PAGE_FILE)

.PHONY: metadata
metadata: $(METADATA_FILE)

# NB: THe PDF strips out all of the metadata from the markdown files for now.
.PHONY: pdf
pdf: $(PDF_FILENAME)

.PHONY: clean
clean:
	-rm $(TITLE_PAGE_FILE)
	-rm $(METADATA_FILE)
	-rm -r $(EPUB_FOLDER)
	-rm -r $(PDF_FOLDER)


$(EPUB_FOLDER):
	mkdir -p $@

$(PDF_FOLDER):
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

$(PDF_FILENAME): $(TITLE_PAGE_FILE) $(addprefix $(PDF_FOLDER)/, $(MD_FILES))
	$(PANDOC) -S -o $@ $^

define MD_SUB
	cp $< $@
	perl -ni -e 'if($$y){if(/^---$$/){$$y=0;next}s/^layout:.*$$//;\
		s/^title:\s*(.*)$$/# $$1/;s/^author:\s*(.*)$$/**$$1**/;print;} \
		$$y = 1 if /^---$$/;print unless $$y' $@
	perl -p0i -e 's/^\s*//' $@
	echo '' >> $@
endef

$(EPUB_FOLDER)/%.md: $(MD_PATH)/%.md | $(EPUB_FOLDER)
	$(MD_SUB)

$(PDF_FOLDER)/%.md: $(MD_PATH)/%.md | $(PDF_FOLDER)
	$(MD_SUB)
