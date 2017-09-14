% INVdoc.cls
% ----------------------------------------------------
% Class as an interface for the KOMA-Script classes optimized for the work at INVENSITY
%
\ProvidesClass{INVdoc}[2016/10/04 v0.1/PROTOTYPE: INVENSITY document class, EKHL et al.]

%\PassOptionsToPackage{twoside,DIV=calc}{typearea}
% Make "@" a regular character
\makeatletter

% CONST VAR for class name
\newcommand*{\sClassName@INVbase}{INVENSITY document class, EKHL et al.}

% Allow choosing the base class type based on passed option

% VAR for the base class
\newcommand*{\sBaseClass@INVbase}{scrartcl} 
\DeclareOption{book}{\renewcommand*{\sBaseClass@INVbase}{scrbook}}
\DeclareOption{report}{\renewcommand*{\sBaseClass@INVbase}{scrreprt}}
\DeclareOption{article}{\renewcommand*{\sBaseClass@INVbase}{scrartcl}}

% VAR for the document language
\newcommand*{\sLanguage@INVbase}{ngerman} 
\DeclareOption{de}{\renewcommand*{\sLanguage@INVbase}{ngerman}}
\DeclareOption{en}{\renewcommand*{\sLanguage@INVbase}{english}}

% VAR for the author
\newcommand*{\sAuthor@INVbase}{EKHL}

% VAR for the usage of colored tables
\newcommand*{\bColoredTables@INVcolor}{0}
\DeclareOption{colortables}{\renewcommand*{\bColoredTables@INVcolor}{1}}

% Pass SCR options to the chosen SCR base class
\DeclareOption*{\expandafter\PassOptionsToClass\expandafter{\CurrentOption}{\sBaseClass@INVbase}}

%Process the defined options
\ProcessOptions\relax
% Load the chosen base class
\LoadClass{\sBaseClass@INVbase}

% Load the required packages
% ----------------------------------------------------
% NOTE: the package inputenc depends on the editor and should be included in the document itself.
%       It was omitted at this point
\Requirepackage[T1]{fontenc}

% Load language package "babel"
\Requirepackage[\sLanguage@INVbase]{babel}

% Load color package
\Requirepackage{color}

% Load package for citations, which are formatted according DIN
\Requirepackage[sort&compress, numbers]{natbib}

% Paket für die \subfloat[]{}-Umgebung.
\Requirepackage[margin=1em, indention=1em]{subfig}

% Load the hyperref package
\Requirepackage[
	pdfauthor={\sAuthor@INVbase},%				     											Autor des PDF Dokuments.
	pdfcreator={LaTeX with hyperref and INVdoc},% 								Erzeuger/Kompiler des PDF Dokuments.
	bookmarksopenlevel={sections},%															 								PDF-Lesezeichen bis zu Sections öffnen.
	pdfpagemode={UseOutlines},%                                  								PDF-Lesezeichen beim Öffnen anzeigen.
	pdfdisplaydoctitle={true},%                                  								Dokumenttitel statt Dateiname in der Titelzeile anzeigen.
	pdfstartview={FitH}%																			 								Größe an Fensterbreite anpassen
]{hyperref}

% Das Caption-Paket erlaubt, die Bildunterschriften der \subfloat[]{}-Umgebung zu formatieren.
\Requirepackage{caption}

% Using graphics
\Requirepackage{graphicx}

% TikZ
\Requirepackage{tikz}
\usetikzlibrary{snakes}

% Allows the usage of eps graphics in TeX
\Requirepackage{epsfig}

% AMS-MATH-Package with standard options
\Requirepackage[sumlimits,intlimits,namelimits]{amsmath}

% AMS-Packages for special symbols
\Requirepackage{amssymb,amscd}

% Symbols for mathematical fields or sets (C,R,N,Q,etc.)
\Requirepackage{dsfont}
%
%			Schriftartensetup: Palatino für Textsatz und Pazomath für Mathesatz
%
\Requirepackage{mathpazo}
%
%			Schriftartensetup: Helvetica als serifenlose Schriftart und Courier für \texttt{}
%
\Requirepackage[scaled = 0.95]{helvet}
\Requirepackage{courier}

% Extended visuals for tqbles - cannot be used with colored tables
\Requirepackage{booktabs}

% allows the usage of a comma as decimal separator
\Requirepackage{ziffer}

% Transforms eps graphics to pdf graphics
\Requirepackage{epstopdf}
%
% ========================================================
% EOF
%
% style_phys.tex
% -------------------------------------------------------------------
% Headerdatei, die das Aussehen und das Layout der Dokumente steuert.
% ===================================================================

%
%  1. Definieren von eigenen benannten Farben.
%     Für spätere Verwendung in dem Dokument, definieren wir einzelne
%     benannte Farben. Sie finden bei den Links, den Überschriften und die spezielle
%			'shadecolor' bei den farbigen Boxen (mit '\begin{shaded}\end{shaded}' gesetzt) Verwendung.
%
\definecolor{LinkColor}{rgb}{0,0,0.6}
\definecolor{HeadColor}{rgb}{0,0,0.5}
\definecolor{shadecolor}{rgb}{0.85,0.95,1}

%
%  2. KOMA-Script Option, Zeilenumbruch bei Bildbeschreibungen.
%
\setcapindent{1em}

%
%  3. Stil der Kopf- und Fusszeilen.
%     Wir aktivieren mit 'headings' laufende Seiten- /Kolumnentitel.
%
\pagestyle{headings}

%
%  4. Definieren der Schriftarten/Schiftfamilien der einzelnen Bereiche.
%
% \setkomafont{chapter}{\huge\scshape\color{HeadColor}}       				% Kapitel farbig, Groß und als Kapitälchen
% \setkomafont{section}{\Large\color{HeadColor}}											% Sections farbig und größer als normal
% \setkomafont{captionlabel}{\sffamily\bfseries\color{HeadColor}}     % Fette Beschriftungstitel, farbig und serifenlos 
% \setkomafont{caption}{\sffamily}																		% serifenlose Beschriftungen (tables/figures)
% \setkomafont{pagehead}{\sffamily\bfseries\color{HeadColor}}         % Kolumnentitel serifenlos, farbig und fett
% \setkomafont{descriptionlabel}{\sffamily\bfseries} 									% Fette und serifenlose Beschreibungstitel
% \setkomafont{pagenumber}{\sffamily\bfseries}												% Fette, serifenlose Seitenzahlen
% \setkomafont{part}{\Huge\scshape\color{HeadColor}}									% 'Part'-Titel Riesig, Kapitälchen und farbig

% Layouteinstellungen für "Subfloats": \subfloat[Titel]{\includegraphics[width=0.5\textwidth]{Pfad/zur/bilddatei.endung}}
\captionsetup[subfigure]{font={sf,footnotesize}, labelformat=simple, labelsep=colon}

%
%  5. Farbeinstellungen für die Links im PDF Dokument.
%
\hypersetup{%
	colorlinks=true,%        Aktivieren von farbigen Links im Dokument (keine Rahmen)
	linkcolor=LinkColor,%    Farbe festlegen.
	citecolor=LinkColor,%    Farbe festlegen.
	filecolor=linkColor,%    Farbe festlegen.
	menucolor=LinkColor,%    Farbe festlegen.
	urlcolor=LinkColor,%     Farbe von URL's im Dokument.
	bookmarksnumbered=true%  Überschriftsnummerierung im PDF Inhalt anzeigen.
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  6. Die Besondere Formatierung der Kapitelüberschriften (Linien drüber und drunter)
%
 
%%1st get a new command
% \newcommand*{\ORIGchapterheadstartvskip}{}%
%%2nd save the original definition to the new command
% \let\ORIGchapterheadstartvskip=\chapterheadstartvskip
%%3rd redefine the command using the saved original command
% \renewcommand*{\chapterheadstartvskip}{%
  % \ORIGchapterheadstartvskip
  % {%
    % \setlength{\parskip}{0pt}%
    % \noindent\rule[.3\baselineskip]{\linewidth}{1pt}\par
  % }%
% }
 
%%see above
% \newcommand*{\ORIGchapterheadendvskip}{}%
% \let\ORIGchapterheadendvskip=\chapterheadendvskip
% \renewcommand*{\chapterheadendvskip}{%
  % {%
    % \setlength{\parskip}{0pt}%
    % \noindent\rule[.3\baselineskip]{\linewidth}{1pt}\par
  % }%
  % \ORIGchapterheadendvskip
% }
%
%  End of chapter head change
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ===========================================================================
% EOF

\makeatother


%
%	command.tex
% -------------------------------------------
%	Headerdatei, die alle nötigen Befehle lädt.
% ===========================================
%
% QM-spezifische Befehle: \bra{} (\tbra{}), \ket{} (\tket{}), \skal{}{} (\tskal{}{}) [Skalarprodukt], \EW{}, \ew{} [Erwartungswert]
%
%
% Allg. mathematische Befehle: \msakl [Skalarprodukt: <*,*>], \dx, \e, \eps, \prt{}{}, \Diff{}, \diff{}{}, \svec{}, \abs{}, \norm{}, \rot, 
%	\laplace
%
\newcommand{\mskal}[2]{\left\langle #1 , #2 \right\rangle}
\newcommand{\dx}{\:\mathrm{\normalfont{d}}}
\newcommand{\e}[1]{\:\mathrm{\normalfont{e}}^{#1}}
\newcommand{\eps}{\varepsilon}
\newcommand{\prt}[2]{\frac{\partial #1}{\partial #2}}
\newcommand{\diff}[2]{\frac{\mathrm{d} #1}{\mathrm{d} #2}} 
\newcommand{\Diff}[1]{\diff{}{#1}}									
\newcommand{\svec}[1]{\begin{pmatrix} #1 \end{pmatrix}} 
\newcommand{\detm}[1]{\begin{vmatrix} #1 \end{vmatrix}}
\newcommand{\abs}[1]{\left|#1\right|}									
\newcommand{\norm}[1]{\left\|#1\right\|}
\DeclareMathOperator{\rot}{rot}
\DeclareMathOperator{\divergence}{div}
\DeclareMathOperator{\erfc}{erfc}
\DeclareMathOperator{\erf}{erf}
\newcommand{\laplace}{{}\hspace{-0.3em}\mathrel{\rotatebox[origin=c]{180}{$\nabla$}}\hspace{-0.3em}}
%
% Abkürzungen für Mathematische Körper und Mengen
%
\newcommand{\N}{\mathds N}
\newcommand{\Z}{\mathds Z}
\newcommand{\R}{\mathds R}
\newcommand{\Q}{\mathds Q}
\newcommand{\C}{\mathds C}
\newcommand{\K}{\mathds K}
\newcommand{\V}{\mathds V}
\newcommand{\I}{\Im}
%
% Aufrecht gesetzter Indextext
%
\newcommand{\tx}[1]{_{\mathrm{#1}}}
%
%  Abkürzung für den \displaybreak[1]. Mit diesem Befehl kann man 'align'-Umgebungen beim Seitenende gezielt umbrechen.
%
\newcommand{\br}{\displaybreak[1]}
%
% Eine Erweiterung des \ref{label}-Befehls: Generiert einen Link, der Aus Objekttyp, Objektidentifikator und Objektcaption zusammengesetzt ist. 
% Bietet sich für Bezüge auf Abschnitte an: \fullref{sec:abschnitt} produziert z.B. 'Abschnitt 1.1 Abschnittstitel'
%
\newcommand{\fullref}[1]{\autoref{#1}: \nameref{#1}}
%
% Umgebung für eine alphabetisch nummerierte Liste
%
\newcounter{ale}
\newcommand{\abc}{\item[\alph{ale})]\stepcounter{ale}}
\newenvironment{liste}{\begin{itemize}}{\end{itemize}}
\newcommand{\aliste}{\begin{liste} \setcounter{ale}{1}}
\newcommand{\zliste}{\end{liste}}
\newenvironment{abcliste}{\aliste}{\zliste}
%	Setzen mit '\aliste\abc Text \zliste'
%
% ============================================
% EOF
%


% ====================================================
% EOF
%