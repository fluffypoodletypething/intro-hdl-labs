\ProvidesClass{handout}
\LoadClass[11pt,letter]{exam}
\def \CourseNumber {ENGR3410}
\def \CourseTitle {Computer Architecture}
\def \CourseSemester {Fall 2023}
\def \Revision {A}
\def \Names {Name}

\usepackage{color}
\usepackage{titlesec}
\usepackage{enumitem}
\usepackage[pdftitle=Title,pdfauthor=Avinash Uttamchandani,pdfdisplaydoctitle]{hyperref}
\usepackage[pdftex]{graphicx}
\usepackage{caption}
\usepackage{longtable}
\usepackage{mathtools}
\usepackage{subcaption}
\usepackage{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=blue,
  filecolor=magenta,      
  urlcolor=cyan,
  pdftitle=\@title,
	pdfauthor={Avinash Uttamchandani}
}
\usepackage{verbatim}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Misc. Customizations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use Sans Serif Font.
\renewcommand{\familydefault}{\sfdefault}

% Paragraphs - no indents, use newlines between.
\usepackage{parskip}

% Make tables look reasonable (better separation).
\renewcommand{\arraystretch}{1.25} 

% Custom command to make annotating equations easier.
\newcommand{\eqnannotate}[1] { \hspace{1em} \textrm{\it \sffamily (#1) } }
% Custom command for Ohms
\newcommand{\Ohms}{ \Omega }

\newcommand{\dataspace}{ \rule[2em]{6em}{0em} }
\newcommand{\dataline}{ \rule[2em]{6em}{.5em} }
\newcommand{\bitblank}{ \rule[-0.1em]{2em}{0.1em} }
\newcommand{\activelow}[1]{$\overline{\mbox{#1}}$}
\newcommand{\strutt}{ \rule[-.3\baselineskip]{0pt}{1.25 \baselineskip} }

\newcommand{\signoff}{
	\ifprintanswers
	\else
	\strutt
	
		\begin{tabular}{| p{1in} | l | p{3.75in} |} %TODO(avinash) make this based on percentages of page width.
			\hline 
			Date & Score & Instructor Sign off  \\ \hline
			\dataspace & \dataspace & \dataspace  \\ \hline
		\end{tabular}
		
	\fi
}

% Set margins.
\usepackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}
\definecolor{SolutionColor}{rgb}{0.4,0.6,0.4}

% Set up the question/solution formatting.
\qformat{{\sffamily\bfseries {\large \thequestion. } \thequestiontitle } \hfill {\sffamily(\totalpoints \rule[0em]{.25em}{0em} points)}  }
\bonusqformat{{\sffamily\bfseries {\large \thequestion . } \thequestiontitle } \hfill {\sffamily(\totalpoints $j$ points)}  }
% \pointname{ \points points}
% \pointpoints{minute}{minutes}
% \shadedsolutions

% Set up title page.
\def\maketitle{%
	%\thispagestyle{empty}% good for clearing out other styles on fullpage title
	{\sffamily\bfseries%
		%\vbox to \vsize{ }%  %good for centering title on page
		\begin{center}%
		\vspace{0.0in}
		%{\Large \CourseNumber \CourseTitle : \CourseSemester} \\%
		{\LARGE \@title}\\%
		\ifdefined\DueDate
			{\it \DueDate }
		\fi
		\end{center}%
	}%
	\ifdefined\NoName
	\else
		\vspace{0.25in}
		\makebox[\textwidth]{Section: \rule{4em}{0.05em}  \enspace \Names: \enspace \hrulefill}

		\vspace{0.15in}
		\makebox[\textwidth]{Collaborators:  \enspace \hrulefill}
	\fi
}

% Sections
\titleformat*{\section}{\Large\sffamily\bfseries\raggedright}
\titleformat*{\subsection}{\large\sffamily\bfseries\raggedright}
\titleformat*{\subsubsection}{\sffamily\bfseries\raggedright}
% Headers and Footers
\pagestyle{headandfoot}
\runningheadrule
\firstpageheader{\CourseNumber}{}{\CourseSemester}
\firstpagefooter{Rev \Revision }{}{\thepage\ of \numpages}
\runningheader{\CourseNumber}{\@title}{\CourseSemester}
\runningfooter{Rev \Revision }{}{\thepage\ of \numpages}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Electronics Things
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\inlineResistor}{ \includegraphics[height=0.5em]{resistor.eps} }
\newcommand{\inlineCapacitor}{ \includegraphics[height=1.0em]{capacitor.eps} }
\newcommand{\inlineInductor}{ \includegraphics[height=0.5em]{inductor.eps} }





\usepackage{comment}
\usepackage{listings}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Verilog Specific Styling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\definecolor{comment_color}{RGB}{00,88,11}

\lstset{ 
language=Verilog,         % language
basicstyle=\footnotesize\ttfamily, % size/font
numbers=left,                   % where to put the line-numbers
numberstyle=\footnotesize,      % the size of line number font
stepnumber=0,                   % the step between two line-numbers. If it's 1, each line 
                                % will be numbered
keywordstyle=\color{blue}\bfseries,
commentstyle=\color{comment_color},
stringstyle=\ttfamily,
numbersep=5pt,                  % how far the line-numbers are from the code
backgroundcolor=\color{white},  % choose the background color. You must add \usepackage{color}
showspaces=false,               % show spaces adding particular underscores
showstringspaces=false,         % underline spaces within strings
showtabs=false,                 % show tabs within strings adding particulaar underscores
frame=single,                   % adds a frame around the code
tabsize=2,                      % sets default tabsize to 2 spaces
captionpos=b,                   % sets the caption-position to bottom
breaklines=true,                % sets automatic line breaking
breakatwhitespace=false,        % sets if automatic breaks should only happen at whitespace
title=\lstname,                 % show the filename of files included with \lstinputlisting;
                                % also try caption instead of title
escapeinside={\%\%}{\%\%)},
frame=none,
morekeywords={*,always_comb,always_ff,always_latch,logic}            % if you want to add more keywords to the set
}
