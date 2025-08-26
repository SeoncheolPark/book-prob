#import "@preview/theorion:0.3.3": *
//#import "@preview/thmbox:0.2.0": *
#import "@preview/cades:0.3.0": qr-code //qrcode
#import "@preview/scienceicons:0.1.0": email-icon, orcid-icon //icon
//#show: thmbox-init(counter-level: 1)

//#show: thmbox-init()
#let default-color = rgb("#0E4A84")
#let supp-color = rgb("898C8E").lighten(75%)
#let h-color = default-color.lighten(75%)
#let b-color = default-color.lighten(85%)
 
#let logo-title = image("images/hanyang.png", width: 30%, fit: "contain")
//#let logo = image("images/hanyang.png", height: 0.8em, fit: "contain")

//diatypst 0.5.0 lib.typ file
#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)

#let lecture(
  title: [],
  subtitle: [],
  authors: (),
  date: datetime.today(),
  department: none,
  institution: none,
  email: none,
  titlemessage: none,
  ratio: 16/9,
  logo: "images/hanyang.png",
  logo-small: "images/hanyang_mini.png",
  qrurl: none,
  abstract: [],
  column: 1,
  lecturetype: "note",//밑에서부터는 slide용
  theme: "full",
  firstlevelheading: true,
  footer-title: none,
  footer-subtitle: none,
  layout: "medium",
  title-font: "Manrope",//"Manrope",//"HK Grotesk", "Manrope", "inter"
  title-color: none,
  main-font: "Noto Sans CJK KR",
  count: "number",
  footer: true,
  toc: true,
  content,
) = if lecturetype=="note"{
  // Set and show rules from before.
  set page(
    paper: "a4",
    margin: (
      top: 2.8cm,
      bottom: 2.8cm,
      left: 1.4cm,
      right: 1.4cm,
    ),
    header:  context [
      #grid(
        columns: (460pt, 1fr, 1fr),
        align: (left, right),
        [
          #set text(11.5pt, font: main-font, weight: "bold")
          #title
        ], 
        [
          #figure(
            image(logo, width:275%, fit:"contain"),
        )],
      )
    ],
    footer: context [
      #set text(11.5pt, font: main-font, weight: "bold")
      #authors
      #h(1fr)
      #counter(page).display(
        "1",
      )
    ],
   
    columns: column,
  )

  // 제목 달기
  place(
  top + center,
  scope: "parent",
  float: true,
  text(19.5pt, weight: "bold", font: main-font)[
    #title
  ],
  )

   place(
  top + center,
  scope: "parent",
  float: true,
  text(11pt, weight: "regular", font: main-font)[
    #authors
  ],
  )


  //let count = authors.len()
  //let ncols = calc.min(count, 3)
  //grid(
   // columns: (1fr,) * ncols,
   // row-gutter: 24pt,
   // ..authors.map(author => [
    //  #author.name \
    //  //#author.affiliation \
    //  //#link("mailto:" + author.email)
    //]),
  //)

  //par(justify: true)[
  //  *Abstract* \
  //  #abstract
  //]

  set heading(numbering: "1.1")

  //(SC) eqn 등
  set math.equation(numbering: n => {
    numbering("(1)", n)
  }, supplement: [])
  show ref: it => {
    // provide custom reference for equations
    if it.element != none and it.element.func() == math.equation {
      highlight(stroke: (thickness: 0.1em, paint: aqua, cap: "round"), fill:none, extent: 0pt)[#link(it.target)[#it]]
    } else if  it.element != none and it.element.func() != math.equation {
      highlight(stroke: (thickness: 0.1em, paint: aqua, cap: "round"), fill:none, extent: 0pt)[#link(it.target)[#it]]
    } else {
      it
    }
  }
  show link: it => {
    if type(it.dest) != str { // Local Links
      it
    }
    else {
      highlight(stroke: (thickness: 0.1em, paint: aqua, cap: "round"), fill:none, extent: 0pt)[#it]
      //underline(stroke: 1pt+fuchsia)[#it] // Web Links
    }
  }
  
  set text(
    font: main-font,
    size: 11pt,
  )

  set align(left)
  content
}else if lecturetype=="slide"{

  // Parsing
  if layout not in layouts {
      panic("Unknown layout " + layout)
  }
  let (height, space) = layouts.at(layout)
  let width = ratio * height

  if count not in (none, "dot", "number") {
    panic("Unknown Count, valid counts are 'dot' and 'number', or none")
  }

  // Colors
  if title-color == none {
      title-color = default-color.darken(0%)
  }
  let block-color = title-color.lighten(90%)
  let body-color = title-color.lighten(80%)
  let header-color = title-color.lighten(65%)
  let fill-color = title-color.lighten(50%)

  // Setup
  set document(
    title: title,
    author: authors,
    //author: authors.map(author => author.name)
  )
  //set heading(numbering: "1.1")
  set heading(numbering: none)

  // PAGE----------------------------------------------
  set page(
    width: width,
    height: height,
    margin: (x: 0.5 * space, top: 0.8 * space, bottom: 0.6 * space),
  // HEADER
    header: [
      #context {
        let page = here().page()
        let headings = query(selector(heading.where(level: 2)))
        //let headings = query(selector(heading.where(level: 2)).or(selector(heading.where(level: 1))))
        let heading = headings.rev().find(x => x.location().page() <= page)

        if heading != none {
          set align(top)

          if (theme == "full") {
            block(
              width: 100%,
              fill: supp-color,
              height: space * 0.625,
              outset: (x: 0.5 * space)
            )[
              #set text(2em, font: title-font, weight: "bold", fill: title-color)
              #v(space / 8)
              #heading.body
              #if not heading.location().page() == page [
                (cont.)
              ]
            ]
          } else if (theme == "normal") {
            set text(2em, font: title-font, weight: "bold", fill: title-color)
            //v(space / 2)
            v(space / 8)
            heading.body
            if not heading.location().page() == page [
              (cont.)
              /*#{numbering("(i)", page - heading.location().page() + 1)}*/
            ]
          }
        }
    }    
    #place(
      top + right,
      /*dx: 5pt,
      dy: 10pt,*/
      dx: 2pt,
      dy: 4pt,
      figure(
            image(logo-small, width:4%, fit:"contain"),
        )
    )
  // COUNTER
  /*
    #if count == "dot" {
      //v(-space / 1.5)
      v(-space / 1.15)
      set align(right + top)
      context {
        let last = counter(page).final().first()
        let current = here().page()
        // Before the current page
        for i in range(1,current) {
          link((page:i, x:0pt,y:0pt))[
            #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt+fill-color))
          ]
        }
        // Current Page
        link((page:current, x:0pt,y:0pt))[
            #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt+fill-color))
          ]
        // After the current page
        for i in range(current+1,last+1) {
          link((page:i, x:0pt,y:0pt))[
            #box(circle(radius: 0.08cm, stroke: 1pt+fill-color))
          ]
        }
      }
    } else if count == "number" {
      //v(-space / 1.5)
      v(-space / 1.15)
      set align(right + top)
      context {
        let last = counter(page).final().first()
        let current = here().page()
        set text(weight: "bold", font: "Noto Sans CJK KR")
        set text(fill: white, font: "Noto Sans CJK KR") 
        set text(fill: title-color, font: "Noto Sans CJK KR")
        [#current / #last]
      }
    }*/
    ],
    header-ascent: 0%,
  // FOOTER
    footer: [
      #if footer == true {
        context{
          let last = counter(page).final().first()
          let current = here().page()
          let ratio = current/last

          set text(0.7em)
          // Colored Style
          box()[#line(length: ratio * 100%, stroke: 2pt+fill-color )]
          box()[#line(length: (1-ratio) * 100%, stroke: 2pt+body-color)]
        }
        
        set text(0.7em)
        //// Colored Style
        //box()[#line(length: 50%, stroke: 2pt+fill-color )]
        //box()[#line(length: 50%, stroke: 2pt+body-color)]
        v(-0.3cm)
        grid(
          columns: (1fr, 1fr),
          align: (left,right),
          inset: (y: 4pt),
          [#smallcaps()[
            #if footer-title != none {
              set text(font: title-font, weight: "semibold")
              footer-title} else {
                set text(font: title-font, weight: "semibold", fill: title-color)
                title}]],
          [// COUNTER
          #if count == "dot" {
            //v(-space / 1.5)
            //v(-space / 1.15)
            set align(right + top)
            context {
              let last = counter(page).final().first()
              let current = here().page()
              // Before the current page
              for i in range(1,current) {
                link((page:i, x:0pt,y:0pt))[
                  #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt+fill-color))
                ]
              }
              // Current Page
              link((page:current, x:0pt,y:0pt))[
                  #box(circle(radius: 0.08cm, fill: fill-color, stroke: 1pt+fill-color))
                ]
              // After the current page
              for i in range(current+1,last+1) {
                link((page:i, x:0pt,y:0pt))[
                  #box(circle(radius: 0.08cm, stroke: 1pt+fill-color))
                ]
              }
            }
          } else if count == "number" {
            //v(-space / 1.5)
            //v(-space / 1.15)
            set align(right + top)
            context {
              let last = counter(page).final().first()
              let current = here().page()
              set text(weight: "semibold", fill: title-color, font: title-font)
              //set text(fill: white, font: "Noto Sans CJK KR") 
              //set text(fill: title-color, font: "Noto Sans CJK KR")
              [#current / #last]
            }
          } else if footer-subtitle != none {
              set text(font: title-font, weight: "semibold", fill: title-color)
              footer-subtitle
          } else if subtitle != none {
              set text(font: main-font, weight: "semibold", fill: title-color)
              subtitle
          } else if authors != none {
                if (type(authors) != array) {authors = (authors,)}
                set text(font: title-font, weight: "semibold", fill: title-color)
                authors.join(", ", last: " and ")
              } else [#date]
          ],
        )
      }
    ],
    footer-descent:0.3*space,
  )


  // SLIDES STYLING--------------------------------------------------
  // Section Slides

  
  show heading.where(level: 1): x => {
    set page(header: none,footer: none, margin: 0cm)
    set align(horizon)
    //  grid(
    //    columns: (1fr, 3fr),
    //    inset: 10pt,
     //   align: (right,left),
    //    fill: (title-color, white), //왼쪽을 바꾸면 색칠하게 됨
    //    [#block(height: 100%)],[#text(1.2em, font: "Noto Sans CJK KR", weight: "bold", fill: title-color)[#x]]
    //  )
    if firstlevelheading==true {
      context{
        let last = counter(page).final().first() 
        let current = here().page() 
        let ratio = current/last 
        block(
          inset: (x:0.5*space, y:7em),
          fill: white, //Presentation 위쪽 색칠
          width: 100%,
          height: 50%,
          [#set align(center)
          #text(1.25em, font: title-font, weight: "bold", fill: title-color, [#x])] + v(30pt) +
          //set text(0.7em) +
          // Colored Style
          box()[#line(length: ratio * 100%, stroke: 2pt+fill-color )] +
          box()[#line(length: (1-ratio) * 100%, stroke: 2pt+body-color)]
        )
      }
    }
    place(
      top + right,
      /*dx: 5pt,
      dy: 10pt,*/
      dx: -20.7pt,
      dy: 4pt,
      figure(
            image(logo-small, width:3.65%, fit:"contain"),
        )
    )
  }

  
  show heading.where(level: 2): pagebreak(weak: true) // this is where the magic happens
  //show heading.where(level: 2).or(heading.where(level: 1)): pagebreak(weak: true) // this is where the magic happens
  show heading: set text(1.5em, font: title-font, fill: title-color) //subsubsection


  // ADD. STYLING --------------------------------------------------
  // Terms
  show terms.item: it => {
    set block(width: 100%, inset: 5pt)
    stack(
      block(fill: header-color, radius: (top: 0.2em, bottom: 0cm), strong(it.term)),
      block(fill: block-color, radius: (top: 0cm, bottom: 0.2em), it.description),
    )
  }

  // Code
  /*show raw.where(block: false): it => {
    box(fill: block-color, inset: 1pt, radius: 1pt, baseline: 1pt)[#text(size:8pt ,it)]
  }

  show raw.where(block: true): it => {
    block(radius: 0.5em, fill: block-color,
          width: 100%, inset: 1em, it)
  }*/

  // Bullet List
  show list: set list(marker: (
    text(fill: title-color)[•],
    text(fill: title-color)[‣],
    text(fill: title-color)[-],
  ))

  // Enum
  let color_number(nrs) = text(fill:title-color)[*#nrs.*]
  set enum(numbering: color_number)

  // Table
  show table: set table(
    stroke: (x, y) => (
      x: none,
      bottom: 0.8pt+black,
      top: if y == 0 {0.8pt+black} else if y==1 {0.4pt+black} else { 0pt },
    )
  )

  show table.cell.where(y: 0): set text(
    style: "normal", weight: "bold", font: main-font) // for first / header row

  set table.hline(stroke: 0.4pt+black)
  set table.vline(stroke: 0.4pt)

  // Quote
  set quote(block: true)
  show quote.where(block: true): it => {
    v(-5pt)
    block(
      fill: block-color, inset: 5pt, radius: 1pt,
      stroke: (left: 3pt+fill-color), width: 100%,
      outset: (left:-5pt, right:-5pt, top: 5pt, bottom: 5pt)
      )[#it]
    v(-5pt)
  }
  
  /*(SC) Figures*/
  show figure.caption: it => {
    set align(left)
    it
  }

  // Outline
  set outline(
    target: heading.where(level: 1).or(heading.where(level:2)),
    indent: auto,
  )

  /*(SC)*/
  show outline.entry: it => link(
    it.element.location(),
    // Keep just the body, dropping
    // the fill and the page.
    it.indented(it.prefix(), it.body()),
  )

  show outline: set heading(level: 2) // To not make the TOC heading a section slide by itself

  // Bibliography
  show bibliography: set heading(level: 2)
  //set bibliography(
  //  title: "Biblography"
  //)


  // CONTENT---------------------------------------------
  // Title Slide
  if (title == none) {
    panic("A title is required")
  }
  else {
    if (type(authors) != array) {
      authors = (authors,)
    }
    set page(footer: none, margin: (
      top: 1*space,
      bottom: 0cm,
      left: 0cm,
      right: 0cm,
    ),
    header: place(
      top + center,
      dx: 189pt,
      dy: 10pt,
      figure(
            image(logo, width:20%, fit:"contain"),
        )
    )
  )
    block(
      inset: (x:0.5*space, y:1em),
      fill: white, //Presentation 위쪽 색칠
      width: 100%,
      height: 50%,
      [#text(2.5em, font: title-font, weight: "bold", fill: title-color, title)] +
      if subtitle != [] { text(1.4em, font: main-font)[ \ ] } + v(-5pt) +
      if subtitle != none {[
        #text(1.4em, font: title-font, fill: title-color, weight: "bold", subtitle)
      ]} else {[
        //#text(1em, font: title-font, fill: title-color, weight: "bold", " ")
      ]}  + v(-5pt) +
      align(center)[#line(length: 100%, stroke: 2pt+fill-color )]
    )
    // Try to auto-size the column block.
    // It's not perfect
    block(
      height: 30%,
      width: 100%,
      inset: (x:0.5*space,top:-0.75cm, bottom: 1em),
      if date != none {text(1.1em, font: title-font, date, weight: "bold")} +
      if authors != none { text(1.4em, font: main-font)[ \ ] } +
      if authors != none { text(1.1em, authors.join(", ", last: " & "), font: title-font, weight: "bold")} + 
      if department != none { text(1.4em, font: main-font)[ \ ] } +
      if department != none {text(1.1em, font: title-font, department, weight: "bold")} + 
      if institution != none { text(1.4em, font: main-font)[ \ ] } +
      if institution != none {text(1.1em, font: title-font, institution, weight: "bold")} +
      if email != none { text(1.4em, font: main-font)[ \ ] } +
      if email != none { 
                set text(1.1em, font: title-font, weight: "bold")
                email-icon(color: title-color, height: 1.0em, baseline: 20%) + link("mailto:", email)} +
      if titlemessage != none { text(1.4em, font: main-font)[ \ ] } +
      if titlemessage != none {
        //text(0.8em, font: title-font, titlemessage, weight: "bold")
        grid(
          columns: (7fr, 3fr),
          rows: (auto, auto),
          gutter: (),
          [#v(-0.55em)
          #text(0.8em, font: title-font, titlemessage, weight: "bold")],
          [],
        )
      }
      //)
      /*for i in range(calc.ceil(authors.len() / 3)) {
        let end = calc.min((i + 1) * 3, authors.len())
        let is-last = authors.len() == end
        let slice = authors.slice(i * 3, end)
        grid(
          columns: slice.len() * (1fr,),
          gutter: -15em,
          ..slice.map(author => align(center, {
            set text(font: title-font)
            set align(left)
            text(size: 1.2em, author.name, weight: "semibold")
            if "department" in author [
              \ #emph(author.department)
            ]
            if "organization" in author [
              \ #emph(author.organization)
            ]
            if "location" in author [
              \ #author.location
            ]
            if "email" in author {
              if type(author.email) == str [
                \ #email-icon(color: title-color, height: 1.0em, baseline: 20%) #link("mailto:" + author.email)
              ] else [
                \ #author.email 
              ]
            }
          }))
        )

        if not is-last {
          v(16pt, weak: true)
        }
      }*/
    )
    if(qrurl!=none){
      place(
      top + center,
      dx: 199pt,
      dy: 138pt,
      qr-code(qrurl, width: 3cm)
      )
    }
  }

  // Outline
  show outline.entry.where(
  level: 1
  ): it => {
    v(1em, weak: true)
    strong(it)
  }
  if (toc == true) {
    set text(1em, font: main-font)
    outline()
  }
  // Normal Content
  set page(columns: column) //내가 넣음
  set text(1em, font: main-font)

  //(SC) eqn 등
  set math.equation(numbering: n => {
    numbering("(1)", n)
  }, supplement: [])
  show ref: it => {
    // provide custom reference for equations
    if it.element != none and it.element.func() == math.equation {
      highlight(stroke: (thickness: 0.1em, paint: aqua, cap: "round"), fill:none, extent: 0pt)[#link(it.target)[#it]]
    } else if  it.element != none and it.element.func() != math.equation {
      highlight(stroke: (thickness: 0.1em, paint: aqua, cap: "round"), fill:none, extent: 0pt)[#link(it.target)[#it]]
    } else {
      it
    }
  }
  show link: it => {
    if type(it.dest) != str { // Local Links
      it
    }
    else {
      highlight(stroke: (thickness: 0.1em, paint: aqua, cap: "round"), fill:none, extent: 0pt)[#it]
      //underline(stroke: 1pt+fuchsia)[#it] // Web Links
    }
  }
  
  content

}
