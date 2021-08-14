# HTML File -> PDF

## Documenter.jl
* not sure

## Mustache.jl
* this can help make templates for html or latex files
  * basically just inserts elements of a Dict into a template for you
* still need to run a shell convert 2 pdf executable to render

## Taro.jl
* Doesn't read html, can write pdf
* Java dependency

## Weave.jl
* requires XeLaTex install and this is problematic
* *XXX NO XXX*

## xhtml2pdf shell executable
* python <=3.8
* can modify CSS
* has page properties and other advanced formatting
* all dependencies install with package manger
* `virtualenv` recommended

https://pypi.org/project/xhtml2pdf/
https://xhtml2pdf.readthedocs.io/en/latest/usage.html#using-with-python-standalone

```sh
conda install -c conda-forge xhtml2pdf

# writes to test.pdf
xhtml2pdf test.html
xhtml2pdf "test/test-*.html"

# can customize CSS, by modifying the default
xhtml2pdf --css-dump > xhtml2pdf-default.css
xhtml2pdf --css=xhtml2pdf-default.css test.html

```

## PyCall option - weasyprint example
basic example
```jl
using PyCall
math = pyimport("math")
math.sin(math.pi / 4) # 0.70710678...

# weasyprint - maybe like this
html = pyimport("weasyprint.HTML")
html("./report.html").write_pdf("/tmp/weasy-report.pdf")

# or straight from pretty_table html string variable
html(df_html).write_pdf("/tmp/weasy-report.pdf")
```

## WEASYPRINT seems popular
https://doc.courtbouillon.org/weasyprint/stable/tutorial.html

* write method overwrites existing file silently
* can add a header or footer with snippets
* INSTALL DEPENDENCIES ARE DEEP

```sh
sudo yum install redhat-rpm-config python-devel python-pip python-setuptools python-wheel python-cffi libffi-devel cairo pango gdk-pixbuf2
```

*weasyprint command line*
```sh
conda install -c conda-forge weasyprint
weasyprint mypage.html out.pdf
```

example CSS
```json
/* For converting to PDF */
body {
  width: 210mm; /* A4 dimension */
}
@page {
  margin:0;
  padding: 0;
}
```

*python way*
```py
from weasyprint import HTML
HTML("./report.html").write_pdf("/tmp/weasy-report.pdf")

# can add CSS stylesheet inline
from weasyprint import HTML, CSS
HTML('http://weasyprint.org/').write_pdf('/tmp/weasyprint-website.pdf',
    stylesheets=[CSS(string='body { font-family: serif !important }')])

# or define as a css object
CSS(string='@page { size: A3; margin: 1cm }')

# logging supported
import logging
logger = logging.getLogger('weasyprint')
logger.addHandler(logging.FileHandler('/path/to/weasyprint.log'))
```


## PDFKIT is wkhtmltopdf **X** LPGLv3 license **X** no good
PDFKIT depends on wkhtmltopdf
Uses QT Webkit rendering
command line utilities

seems pretty modern, github release jun 2020

https://github.com/wkhtmltopdf/wkhtmltopdf
https://pypi.org/project/pdfkit/
conda install -c conda-forge python-pdfkit

