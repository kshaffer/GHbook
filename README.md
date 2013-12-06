This is a minimal template for creating an online ebook to be published on GitHub.

## Makefile

The Makefile provides an easy way to generate both an ePub and PDF version of
the book. To use it, first open the Makefile and change the relevant
variables. You'll definitely want to change the title and author, as well as
the `MD_FILES` variable, where you should list all of the markdown files in
the order you want them in the book. Note that you'll need
[pandoc](http://johnmacfarlane.net/pandoc) installed in order for this to work
properly.

Once this is all set up, make sure you are in the root directory of the
project (the one with this README file in it), where you can type `make` at
the prompt to generate the files:

`make epub` -- generate all of the necessary files for creating an ePub, then
create the ePub file itself.

`make pdf` -- generate all of the necessary files for creating the PDF.

`make clean` -- delete of all of the extra build files
