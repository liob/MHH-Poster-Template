\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mhh-poster}[2016/03/29 Hannover Medical School Poster Template]
\LoadClass{article}
\pagestyle{empty}

\RequirePackage{geometry}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{tikz}
\RequirePackage{calc}
\RequirePackage{ifthen}
\RequirePackage{anyfontsize}
\RequirePackage{varwidth}
\RequirePackage{authblk}
\RequirePackage{tgpagella}
\RequirePackage[T1]{fontenc}
\RequirePackage{titlesec}
\RequirePackage[absolute,overlay]{textpos}
\usepackage{environ}


\newsavebox{\measure@tikzpicture}
\NewEnviron{scaletikzpicturetowidth}[1]{%
  \def\tikz@width{#1}%
  \def\tikzscale{1}\begin{lrbox}{\measure@tikzpicture}%
  \BODY
  \end{lrbox}%
  \pgfmathparse{#1/\wd\measure@tikzpicture}%
  \edef\tikzscale{\pgfmathresult}%
  \BODY
}
\newlength{\mypaperwidth}
\setlength{\mypaperwidth}{\paperwidth+1.22in}

\DeclareOption{draft}{
	}
\ProcessOptions


% setting up page geometry
\geometry{
		left=0.1\paperwidth,
		right=0.1\paperwidth,
        top=0pt,
		bottom=0pt,
	    }

% ToDo: make normalsize dependant on sqrt(\paperwidth*\paperheight)
%\RequirePackage{fp}
%\FPeval{AR}{pow(\the\paperwidth,4)}
%\SQUAREROOT{\paperwidth*\paperheight}{\solution}
\newlength\AR{}
\setlength{\AR}{0.01\paperwidth}
\newlength\tAR{}
\newcommand\textmagnification[1]{
	\setlength{\tAR}{\AR*\real{#1}}
	
	\renewcommand{\tiny}{\fontsize{0.6\tAR}{0.62\tAR}\selectfont}
	\renewcommand{\scriptsize}{\fontsize{0.7\tAR}{0.72\tAR}\selectfont}
	\renewcommand{\footnotesize}{\fontsize{0.8\tAR}{0.82\tAR}\selectfont}
	\renewcommand{\small}{\fontsize{0.9\tAR}{0.92\tAR}\selectfont}
	\renewcommand{\normalsize}{\fontsize{\tAR}{1.02\tAR}\selectfont}
	\renewcommand{\large}{\fontsize{1.2\tAR}{1.22\tAR}\selectfont}
	\renewcommand{\Large}{\fontsize{1.4\tAR}{1.42\tAR}\selectfont}
	\renewcommand{\LARGE}{\fontsize{1.6\tAR}{1.62\tAR}\selectfont}
	\renewcommand{\huge}{\fontsize{1.8\tAR}{1.82\tAR}\selectfont}
	\renewcommand{\Huge}{\fontsize{2\tAR}{2.02\tAR}\selectfont}
}
\textmagnification{1}

\newlength\hAR{}
\newlength\titlefontsize{}
\newcommand\titlemagnification[1]{
	\setlength{\hAR}{\AR*\real{#1}}
    \setlength{\titlefontsize}{3.53\hAR}
    \renewcommand\Authfont{\fontsize{0.5\titlefontsize}{1}\selectfont}
    \renewcommand\Affilfont{\fontsize{0.3\titlefontsize}{1}\itshape}
}
\titlemagnification{1}

\newlength\institutefontsize{}
\newcommand\institutemagnification[1]{
    \setlength{\institutefontsize}{\AR*\real{#1}}
}
\institutemagnification{1}


\setlength{\columnsep}{0.04\textwidth}
\linespread{1.25}
\setlength{\parindent}{0.02\textwidth}

\definecolor{mhhorange}{rgb}{0.94117647058, 0.23529411764, 0.15294117647}
\definecolor{mhhgray}{rgb}{0.43921568627, 0.41960784313, 0.39607843137}
\definecolor{umred}{rgb}{0.74901961, 0.062745098, 0.16862745}
\definecolor{umgray}{rgb}{0.25098039, 0.25098039, 0.25098039}
\definecolor{umlightgray}{rgb}{0.74901961, 0.74901961, 0.74901961}
\definecolor{title}{rgb}{0,0,0}
\definecolor{author}{rgb}{0,0,0}
\definecolor{ornament}{rgb}{0.74901961, 0.062745098, 0.16862745}

% set section style
\titleformat{\section}
  {\Large\scshape}
  {}{0em}
  {}
  [\color{mhhorange}\titlerule]

\newcommand\headerstring{}
\newcommand\header[1]{\renewcommand\headerstring{#1}}
\newcommand\footerstring{}
\newcommand\footer[1]{\renewcommand\footerstring{#1}}
\newcommand\contactstring{}
\newcommand\contact[1]{\renewcommand\contactstring{#1}}
\newcommand\institutestring{}
\newcommand\institute[1]{\renewcommand\institutestring{#1}}

\newcommand\overlayimg{}
\newboolean{overlayimg_isset}
\newcommand\overlay[1]{
	\renewcommand\overlayimg{#1}%
	\setboolean{overlayimg_isset}{true}
	}

\newcommand\gradientcolorA{}
\newcommand\gradientcolorB{}
\newcommand\gradientcolorAngle{}
\newboolean{gradientcolors_isset}
\newcommand\gradient[3]{
	\renewcommand\gradientcolorA{#1}%
	\renewcommand\gradientcolorB{#2}%
	\renewcommand\gradientcolorAngle{#3}%
	\setboolean{gradientcolors_isset}{true}
	}

\newcommand\affillist{\AB@affillist{}\\}

\newcommand*{\vcenteredhbox}[1]{\begingroup
\setbox0=\hbox{#1}\parbox{\wd0}{\box0}\endgroup}


\AtBeginDocument{
	%
	\hypersetup{
		unicode=false,            % non-Latin characters in Acrobat's bookmarks
		pdftoolbar=true,          % show Acrobat's toolbar?
		pdfmenubar=true,          % show Acrobat's menu?
		pdffitwindow=true,        % window fit to page when opened
		pdfstartview={FitH},      % fits the width of the page to the window
		pdftitle={\@title},       % title
		pdfauthor={\AB@authlist}, % author
		pdfnewwindow=true        % links in new window
		%colorlinks=false          % false: boxed links; true: colored links
	}
	%
	% bg gradient
	\ifthenelse{\boolean{gradientcolors_isset}}{
	    \noindent
		\begin{tikzpicture}[remember picture, overlay]
			\node[inner sep=0pt] at (current page.center) {
				\begin{tikzpicture}
				\shade[shading=axis,bottom color=\gradientcolorB,top color=\gradientcolorA,shading angle=\gradientcolorAngle]
				(0,0) rectangle (\paperwidth,\paperheight);
				\end{tikzpicture}
			};
		\end{tikzpicture}
	}{}
	%
	% header
	\noindent \hspace{\dimexpr -\oddsidemargin -2in}
	\begin{scaletikzpicturetowidth}{\mypaperwidth}
	    \begin{tikzpicture}[scale=\tikzscale]
			\draw [ultra thick, draw=mhhgray, fill=mhhgray]
				(0,0.14) -- (0,1.14) -- (8.2,1.14) -- (8.2,0.14) -- cycle;
			\draw [ultra thick, draw=mhhorange, fill=mhhorange]
				(0,0) -- (0,0.14) -- (8.2,0.14) -- (8.2,0) -- cycle;
	    \end{tikzpicture}
	\end{scaletikzpicturetowidth}
	%
	\begin{textblock}{1}(0,0.2)
	   \noindent \makebox[\paperwidth]{
	       \hspace{\dimexpr \oddsidemargin + 1in -0.5\oddsidemargin}
	       \raisebox{-0.5\height}{
	           \begin{minipage}{0.5\paperwidth}
	               \fontsize{\institutefontsize}{1}
	               {\selectfont\textcolor{white} {\institutestring}}
	           \end{minipage}
	       }
	       \hfill
	       \raisebox{-0.5\height}{
	       \includegraphics[width=0.32\paperwidth]{mhh_logo_white.pdf}
	       }
	       \hspace{\dimexpr \oddsidemargin + 1in -0.5\oddsidemargin}
	   }
	\end{textblock}
    %
	% title section
	\noindent\begin{minipage}{\textwidth}
	    \vspace{2\hAR}
	    \fontsize{\titlefontsize}{1}
		\setlength{\baselineskip}{4em}
			{\textbf{{\selectfont\textcolor{title} {\scshape \@title}}}}
	\end{minipage}
	\noindent\begin{minipage}{\textwidth}
	    \vspace{2\hAR}
	    \AB@authlist
	\end{minipage}
	\noindent\begin{minipage}{\textwidth}
    	\vspace{\hAR}
	    \affillist
	\end{minipage}
	\vfill
}

\AtEndDocument{
	\vfill
	
	% footer section
	\noindent\begin{minipage}{\textwidth}
		\footerstring
		\bigskip
	\end{minipage}
	
	%overlay
	\begin{tikzpicture}[remember picture, overlay]
		\node[inner sep=0pt] at (current page.center) {%
			\ifthenelse{\boolean{overlayimg_isset}}{
				\includegraphics[width=\paperwidth,height=\paperheight]{\overlayimg}
			}{}
		};%
	\end{tikzpicture}
	
	\noindent \hspace{\dimexpr -\oddsidemargin -2in}
	\begin{scaletikzpicturetowidth}{\mypaperwidth}
	    \begin{tikzpicture}[scale=\tikzscale]
			\draw [ultra thick, draw=mhhgray, fill=mhhgray]
				(0,0) -- (0,0.2) -- (8.2,0.2) -- (8.2,0) -- cycle;
	    \end{tikzpicture}
	\end{scaletikzpicturetowidth}
}
