% Class für Abgaben, etc.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mywork}

\LoadClass{scrartcl}

%==================================
% Options
%==================================

% [noproofs] compile without proofs
% ---------------------------------
\DeclareOption{noproofs}{
    \AtEndOfClass{
        \RequirePackage{environ}
        \let\proof\relax
        \let\endproof\relax
        \NewEnviron{proof}{}
    }
}

\ProcessOptions\relax


%==================================
% Fonts / Encoding
%==================================

\usepackage[ngerman]{babel} 	% Deutsche Sprachunterstützung für Silbentrennung, etc.
\usepackage[T1]{fontenc}		% Erlaubt das kopieren/suchen von/nach Umlauten im pdf-Dokument
\usepackage[utf8]{inputenc}		% Encoding der tex-Dateien, erlaubt direkte Eingabe von Sonderzeichen
\usepackage{lmodern}			% Schönere Schriftart für pdf-Dokumente

%==================================
% 
%==================================

%\usepackage[l2tabu, orthodox]{nag}

\usepackage[a4paper, left=20mm, right=20mm, top=20mm, bottom=30mm]{geometry}
\usepackage[svgnames,x11names]{xcolor}  % ana3 needs x11names

%\usepackage[hidelinks]{hyperref}			% Macht Referenzen im pdf-Dokument anklickbar
\usepackage{hyperref}			% Macht Referenzen im pdf-Dokument anklickbar
\hypersetup{
    colorlinks=false,
    pdfborder={0 0 0},
}

\usepackage{enumerate}			% Aufzählungen wie a), (I), etc. als optionales Argument
\usepackage{parskip}			% Entfernt Einrückung bei Absätzen und fügt vertikalen Abstand ein
\usepackage{float}              % Erlaubt [H] Option für table/figure
%\usepackage{scrhack} 			% Wegen float-package, das eine warnung mit scrbook erzeugt

\usepackage{algpseudocode}		% algorithmicx package für Pseudo-Code
\usepackage{verbatim}			% Für Ascii-Art ;-)

\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{mathtools}
\usepackage[hyperref,thmmarks]{ntheorem}			% Alternative theorems für leichteres Anpassen
%\usepackage{tikz}


\usepackage{listings}			% Einbinden von Code-Schnipsel
% Hack um deutsche Sonderzeichen in lstinputlisting zu unterstützen
\lstset{literate={Ö}{{\"O}}1{Ä}{{\"A}}1{Ü}{{\"U}}1{ß}{{\ss}}2{ü}{{\"u}}1{ä}{{\"a}}1{ö}{{\"o}}1}
\lstset{
  basicstyle=\small\ttfamily,
  numbers=left,
  columns=fullflexible,
  breaklines=true,
  mathescape=true,
  escapechar=\#,
  tabsize=4,
  frame=lines,
  showstringspaces=false
}

%========================
% Theorems (TODO: extra package)
%========================

% TODO: \theoremheadertypefont{bla} sollte funktionieren, wie?
\def\theorem@headertypefont{\color{green!25!black}}

\newtheoremstyle{mythm}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\theorem@headertypefont##1}\ \color{black}##2\theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\theorem@headertypefont##1}\ \color{black}##2\ (##3)\theorem@separator}\hbox{\strut}}}]}
\newtheoremstyle{nonumbermythm}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\theorem@headertypefont##1}\ \theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\theorem@headertypefont##1}\ (##3)\theorem@separator}\hbox{\strut}}}]}
\theoremstyle{mythm} 								% Vordefinierter Style mit Zeilenumbruch


% Deprecated: (use \theorempreskip instead)
\theorempreskipamount 2.5em 						% Abstand vor Theorem
\theoremindent 2ex 									% Theorem einrücken
\theoremheaderfont{\kern-1em\normalfont\bfseries} 	% Überschrift wieder ausrücken
%\theoremheadertypefont{\color{green!25!black}}% Font für Theorem-Typ (Satz, Definition, etc.)
\theorembodyfont{\normalfont} 						% Aufrecht statt kursiv im body-Teil
%\theoremprework{
%	\def \theorem@headertypefont{\the\theoremheadertypefont}
%}

% Nummerierung ist anders in scrbook (Skripte) <-> scrartcl (Abgaben)
\@ifclassloaded{scrbook}{
	\newtheorem{thm}{Theorem}
}{
	\newtheorem{thm}{Theorem}
}
\renewtheorem*{thm*}{Theorem}
\newtheorem{st}[thm]{Satz}
\renewtheorem*{st*}{Satz}
\newtheorem{lem}[thm]{Lemma}
\renewtheorem*{lem*}{Lemma}
\newtheorem{df}[thm]{Definition}
\renewtheorem*{df*}{Definition}
\newtheorem{kor}[thm]{Korrolar}
\renewtheorem*{kor*}{Korrolar}
\newtheorem{prop}[thm]{Proposition}
\renewtheorem*{prop*}{Proposition}
\newtheorem{alg}[thm]{Algorithmus}
\renewtheorem*{alg*}{Algorithmus}

%\theoremheadertypefont{\color{black}} % Font für Theorem-Typ (Satz, Definition, etc.)
\theoremstyle{break}

\newtheorem{nt}[thm]{Bemerkung}
\renewtheorem*{nt*}{Bemerkung}
\newtheorem{ex}[thm]{Beispiel}
\renewtheorem*{ex*}{Beispiel}

\theorempreskipamount 1.5em 								% Abstand vor Theroem
\theoremheaderfont{\kern-1em\bfseries\small\itshape}% Kursiv und kleiner als oben

\newtheorem*{note}{Bemerkung}

% Beweis
% TODO: Beweissymbol taucht nicht auf, wenn Beweis mit einer environment abgeschlossen wurde
\theoremsymbol{\ensuremath{\square}}
\newtheorem*{proof}{Beweis}
\theoremsymbol{}



% Segment-Environment für kleinere gedankliche Abschnitte
% TODO: Abstand ist nicht optimal, wenn vor segment-Umgebung eine andere environment war und kein text.
\theoremstyle{emptybreak}
\theoremheaderfont{\kern-2em\bfseries\small}
\theoremindent 2em 									% Theroem einrücken
\theoremprework{
	%\setlength\theorempreskipamount{5ex}\setlength\theorempostskipamount{5cm}
	\ \\ % Erzwinge Absatz, sonst komische Überschneidungsprobleme
	\vspace{-2em}
	%\topsep
}
\newtheorem{seg}{}

\usepackage{fancyhdr}
\usepackage{calc}
\pagestyle{fancy}

\fancyhead{}
\fancyfoot{}

\@ifclassloaded{scrbook}{
	\fancyheadoffset[RE,LO]{\marginparsep+\marginparwidth}
	%\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
	%\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}
	\renewcommand{\chaptermark}[1]{\markboth{\thechapter ~ \textbar ~ #1}{}}
	\renewcommand{\sectionmark}[1]{\markright{\thesection ~ \textbar ~ #1}}
	\fancyhf{}
	\newcommand{\headerfont}{\bfseries \scshape \color{gray}}
	\fancyfoot[LE,RO]{\bfseries\color{gray} \thepage}
	\fancyhead[RO]{\headerfont\rightmark}
	\fancyhead[LE]{\headerfont\leftmark}
	\renewcommand{\headrulewidth}{0.4pt}

	\renewcommand{\headrule}{{\color{gray}%
	\hrule width\headwidth height\headrulewidth \vskip-\headrulewidth}}


	% Pagestyle used in titlepages
	\fancypagestyle{plain}{
	  \fancyhf{}                        % Clear header/footer
	  \fancyfoot[LE,RO]{\bfseries\color{gray} \thepage}
	  \renewcommand{\headrulewidth}{0pt}
	}
}{
}

%========================
% Common Math Things
%========================

\RequirePackage{mymath}


 \usepackage{fancyhdr}
 \pagestyle{fancy}
 \usepackage{titling}

\author{Matthias Hofmann}

%\theoremstyle{break}
%\theorembodyfont{\normalfont}
%\theorempreskipamount 1.5em
%\theoremindent 1em
%\theoremheaderfont{\kern-1em\normalfont\bfseries}
%\newtheorem*{seg}{}

