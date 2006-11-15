% ocreport.cls
% Olaf Conradi <olaf@conradi.org>
%
% Released under GPL version 2.
%
% A document class for writing reports.
%
%
% Document class options
%
% The same options as the standard report document class as distributed
% by most TeX distributions.
%
%
% The hyperref package
%
% If the hyperref package is detected, the title and author information is
% stored as metadata inside PDF output.
%
% To declare other hyperref options, either use \hypersetup in the preamble or
% specify the options with
% \usepackage[options]{hyperref}
%
%
% The Graphicx package
%
% Depending on the output format, pdf or not, set the supported graphics
% extensions.
%
%
% Bibliography
%
% Add bibliography to table of contents. Works also with natbib.
%
%
% TODO
% * Create a custom \maketitle.
% * Implement logo option, require package graphicx when used.

\NeedsTeXFormat{LaTeX2e}

\def\@oc@classname{ocreport}
\def\@oc@baseClassname{report}
\ProvidesClass{\@oc@classname}[2006/05/18 v0.2 Custom report class by Olaf Conradi]

% These packages are necessary for the parsing of options.
\RequirePackage{xkeyval}
\RequirePackage{ifpdf}
\RequirePackage{ifthen}

\providecommand{\ifthen}[2]{\ifthenelse{#1}{#2}{}}
\providecommand{\isempty}[1]{\equal{#1}{}}

% Option storage.
\newcommand{\@oc@papertype}{unknown}

\newlength{\@oc@marginparwidth}
\setlength{\@oc@marginparwidth}{\z@}

\newcounter{@oc@pointsize}
\setcounter{@oc@pointsize}{-1}

\newboolean{@oc@optionWide}
\setboolean{@oc@optionWide}{false}

\newboolean{@oc@optionTwoSide}
\setboolean{@oc@optionTwoSide}{false}

\newboolean{@oc@optionDoubleSpace}
\setboolean{@oc@optionDoubleSpace}{false}

% These options become true in \atbegindocument if the package is loaded.
\newboolean{@oc@titlesecUsed}
\setboolean{@oc@titlesecUsed}{false}

\newboolean{@oc@titletocUsed}
\setboolean{@oc@titletocUsed}{false}

\newboolean{@oc@hyperrefUsed}
\setboolean{@oc@hyperrefUsed}{false}

\newboolean{@oc@graphicxUsed}
\setboolean{@oc@graphicxUsed}{false}

\newboolean{@oc@listingsUsed}
\setboolean{@oc@listingsUsed}{false}

\newboolean{@oc@fixmeUsed}
\setboolean{@oc@fixmeUsed}{false}

\newboolean{@oc@natbibUsed}
\setboolean{@oc@natbibUsed}{false}

% Option declaration.
\DeclareOption{a4paper}{\renewcommand{\@oc@papertype}{a4paper}}
\DeclareOption{a5paper}{\renewcommand{\@oc@papertype}{a5paper}}
\DeclareOption{b5paper}{\renewcommand{\@oc@papertype}{b5paper}}
\DeclareOption{letterpaper}{\renewcommand{\@oc@papertype}{letterpaper}}
\DeclareOption{legalpaper}{\renewcommand{\@oc@papertype}{legalpaper}}
\DeclareOption{executivepaper}{\renewcommand{\@oc@papertype}{executivepaper}}

\DeclareOption{10pt}{\setcounter{@oc@pointsize}{10}}
\DeclareOption{11pt}{\setcounter{@oc@pointsize}{11}}
\DeclareOption{12pt}{\setcounter{@oc@pointsize}{12}}

\DeclareOption{wide}{\setboolean{@oc@optionWide}{true}}
\DeclareOption{twoside}{\setboolean{@oc@optionTwoSide}{true}}

\DeclareOption{doublespace}{\setboolean{@oc@optionDoubleSpace}{true}}

% Pass all other options to the base document class.
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{\@oc@baseClassname}%
  \PassOptionsToPackage{\CurrentOption}{geometry}%
}

% Declare default options.
% Override them in the option list of \documentclass, if you don't like them.
\ExecuteOptions{a4paper,12pt}
\ProcessOptions\relax

% Pass the paper type to the base document class and the packages
% geometry and hyperref.
\ifthenelse{\equal{\@oc@papertype}{unknown}}{%
  \ClassWarning{\@oc@classname}%
    {No paper type option passed to document class `\@oc@classname'.}
}{%
  \PassOptionsToClass{\@oc@papertype}{\@oc@baseClassname}
  \PassOptionsToPackage{\@oc@papertype}{geometry}
  \PassOptionsToPackage{\@oc@papertype}{hyperref}
}

% Pass the point size down to the base document class.
\ifthenelse{\value{@oc@pointsize} = -1}{%
  \ClassWarning{\@oc@classname}%
    {No point size option passed to document class `\@oc@classname'.}
}{%
  \PassOptionsToClass{\the@oc@pointsize pt}{\@oc@baseClassname}
}

% Select a geometry according to paper type and point size.
\ifthenelse{\equal{\@oc@papertype}{a4paper}}{%
  \ifthenelse{\value{@oc@pointsize} = 10}{%
    \ifthenelse{\boolean{@oc@optionWide}}{%
      \PassOptionsToPackage{width=380pt,lines=53}{geometry}
    }{%
      \PassOptionsToPackage{width=345pt,lines=50}{geometry}
    }%
  }{%
    \ifthenelse{\value{@oc@pointsize} = 11}{%
      \ifthenelse{\boolean{@oc@optionWide}}{%
        \PassOptionsToPackage{width=385pt,lines=47}{geometry}
        \setlength{\@oc@marginparwidth}{70pt}%
      }{%
        \PassOptionsToPackage{width=360pt,lines=44}{geometry}
        \setlength{\@oc@marginparwidth}{90pt}%
      }%
    }{%
      \ifthenelse{\value{@oc@pointsize} = 12}{%
        \ifthenelse{\boolean{@oc@optionWide}}{%
          \PassOptionsToPackage{width=425pt,lines=44}{geometry}
        }{%
          \PassOptionsToPackage{width=390pt,lines=41}{geometry}
        }%
      }{%
        \ClassWarning{\@oc@classname}%
          {Geometry settings for point size `\the@oc@pointsize pt' on paper type `\@oc@papertype' have not yet been optimized.}
        \ifthenelse{\boolean{@oc@optionWide}}{%
          \PassOptionsToPackage{scale={0.7,0.75},heightrounded,verbose}{geometry}
        }{%
          \PassOptionsToPackage{scale={0.6,0.7},heightrounded,verbose}{geometry}
        }%
      }%
    }%
  }%
}{%
  \ifthenelse{\equal{\@oc@apertype}{letterpaper}}{%
    \ifthenelse{\value{@oc@pointsize} = 10}{%
      \PassOptionsToPackage{width=345pt,lines=46}{geometry}
    }{%
      \ifthenelse{\value{@oc@pointsize} = 11}{%
        \PassOptionsToPackage{width=360pt,lines=40}{geometry}
      }{%
        \ifthenelse{\value{@oc@pointsize} = 12}{%
          \PassOptionsToPackage{width=390pt,lines=38}{geometry}
        }{%
          \ClassWarning{\@oc@classname}%
            {Geometry settings for point size `\the@oc@pointsize pt' on paper type \@oc@papertype' have not yet been optimized.}
          \PassOptionsToPackage{scale={0.65,0.7},heightrounded,verbose}{geometry}
        }%
      }%
    }%
  }{%
    \ClassWarning{\@oc@classname}%
      {Geometry settings for paper type \@oc@papertype' have not yet been optimized.}
    % Use default settings of geometry.
    \PassOptionsToPackage{heightrounded,verbose}{geometry}
  }%
}

\ifthen{\boolean{@oc@optionTwoSide}}{%
  \PassOptionsToClass{twoside}{\@oc@baseClassname}%
  \PassOptionsToPackage{twoside}{geometry}%
  \ifthen{\lengthtest{\@oc@marginparwidth > \z@}}{%
    \multiply\@oc@marginparwidth by 6%
    \divide\@oc@marginparwidth by 5%
  }%
}

\ifthen{\lengthtest{\@oc@marginparwidth > \z@}}{%
  \PassOptionsToPackage{marginparwidth=\@oc@marginparwidth}{geometry}%
}

% Enable double spacing.
\ifthen{\boolean{@oc@optionDoubleSpace}}{%
  \RequirePackage{setspace}%
  \doublespacing
}

% Options specific to tex output mode:
% * Set common hyperref options.
% * Set PDF compression to highest level.
\ifthenelse{\boolean{pdf}}{%
  \PassOptionsToPackage{pdftex,plainpages=false,pdfpagelabels=true,pdfstartview=FitH}{hyperref}%
  \pdfcompresslevel=9%
}{%
  \PassOptionsToPackage{dvips,plainpages=false}{hyperref}%
}

% Finally load the base document class.
\LoadClass{\@oc@baseClassname}
\RequirePackage{geometry}
% Don't \RequirePackage{hyperref}, let the user include it in the preamble.

% Define name of title page for use in PDF bookmarks.
\newcommand{\titlename}{Title page}

\newcommand{\@oc@makePdfProperties}{%
  \ifthen{\boolean{@oc@hyperrefUsed}}{%
    \hypersetup{%
      pdftitle={\@title},%
      pdfauthor={\@author}%
    }%
    \currentpdfbookmark{\titlename}{titlepage}%
  }%
}

% Extra titlepage commands.
\newcommand{\submitted}[1]{\gdef\@submitted{#1}}
\newcommand{\committee}[1]{\gdef\@committee{#1}}
\newcommand{\department}[1]{\gdef\@department{#1}}
\newcommand{\faculty}[1]{\gdef\@faculty{#1}}
\newcommand{\university}[1]{\gdef\@university{#1}}

% Add author and title metadata to PDF output.
\renewcommand{\maketitle}{%
  \@oc@makePdfProperties
  \begin{titlepage}%
    \let\footnotesize\small
    \let\footnoterule\relax
    \let\footnote\thanks
    \null\vfill
    \label{titlepage}%
    \begin{center}%
      {\huge\sffamily\@title\par}%
      \vskip 3em%
      {\large\@submitted\par}%
      \vskip 3em%
      {\Large\@author\par}%
      \vskip 1.5em%
      {\large\@date\par}%
    \end{center}%
    \null\vfill
    \begin{minipage}[t]{7cm}%
      \begin{flushleft}%
        {\sffamily Research Group}%
        \vskip 1em%
        \@department \\
        \@faculty \\
        \@university
      \end{flushleft}%
    \end{minipage}%
    \hfill
    \begin{minipage}[t]{5cm}%
      \begin{flushright}%
        {\sffamily Graduation Committee}%
        \vskip 1em%
        \@committee
      \end{flushright}%
    \end{minipage}%
    \vskip 50pt%
    \par\noindent
    \includegraphics[totalheight=25mm,keepaspectratio=true]{treselogo}%
    \hfill
    \includegraphics[totalheight=20mm,keepaspectratio=true]{utlogo}%
    \@thanks
    \null
  \end{titlepage}%
  \setcounter{footnote}{0}%
}

% Add list of figures to table of contents.
\let\@oc@listoffigures@orig=\listoffigures
\renewcommand{\listoffigures}{%
  \ifthenelse{\isundefined{\chapter}}{%
    \phantomsection
    \addcontentsline{toc}{section}{\listfigurename}
  }{%
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{\listfigurename}
  }
  \@oc@listoffigures@orig
}

% Add list of tables to table of contents.
\let\@oc@listoftables@orig=\listoftables
\renewcommand{\listoftables}{%
  \ifthenelse{\isundefined{\chapter}}{%
    \phantomsection
    \addcontentsline{toc}{section}{\listtablename}
  }{%
    \clearpage
    \phantomsection
    \addcontentsline{toc}{chapter}{\listtablename}
  }
  \@oc@listoftables@orig
}

% Add extra preamble definitions.
\AtBeginDocument{%
  \@ifpackageloaded{titlesec}{%
    \setboolean{@oc@titlesecUsed}{true}%
  }{%
    \setboolean{@oc@titlesecUsed}{false}%
  }%
  \@ifpackageloaded{titletoc}{%
    \setboolean{@oc@titletocUsed}{true}%
  }{%
    \setboolean{@oc@titletocUsed}{false}%
  }%
  \@ifpackageloaded{hyperref}{%
    \setboolean{@oc@hyperrefUsed}{true}
  }{%
    \setboolean{@oc@hyperrefUsed}{false}
  }
  \@ifpackageloaded{graphicx}{%
    \setboolean{@oc@graphicxUsed}{true}
  }{%
    \setboolean{@oc@graphicxUsed}{false}
  }
  \@ifpackageloaded{listings}{%
    \setboolean{@oc@listingsUsed}{true}
  }{%
    \setboolean{@oc@listingsUsed}{false}
  }
  \@ifpackagewith{fixme}{draft}{%
    \setboolean{@oc@fixmeUsed}{true}
  }{%
    \setboolean{@oc@fixmeUsed}{false}
  }
  \@ifpackageloaded{natbib}{%
    \setboolean{@oc@natbibUsed}{true}
  }{%
    \setboolean{@oc@natbibUsed}{false}
  }

  % Set default graphics extension according to tex output mode.
  \ifthenelse{\boolean{pdf}}{%
    \ifthen{\boolean{@oc@graphicxUsed}}{%
      \DeclareGraphicsExtensions{.pdf,.png,.jpg,.jpeg,.gif,.tif,.tiff}%
      \DeclareGraphicsRule{*}{mps}{*}{}%
    }%
  }{%
    \ifthen{\boolean{@oc@graphicxUsed}}{%
      \DeclareGraphicsExtensions{.eps}%
    }%
  }%

  % If package titlesec not loaded, define chapter spacing in listof.. lists.
  \ifthenelse{\boolean{@oc@titlesecUsed}}\@empty{%
    \newcommand{\ttl@tocsep}{\addvspace{10\p@}}%
  }%
  % Add chapter spacing to list of listings.
  \let\@oc@chaptertolol=\@empty
  \ifthen{\boolean{@oc@listingsUsed}}{%
    \renewcommand{\@oc@chaptertolol}{%
      \addtocontents{lol}{\protect\ttl@tocsep}%
    }%
  }%
  % Add chapter spacing to list of corrections.
  \let\@oc@chaptertolox=\@empty
  \ifthen{\boolean{@oc@fixmeUsed}}{%
    \renewcommand{\@oc@chaptertolox}{%
      \addtocontents{lox}{\protect\ttl@tocsep}%
    }%
  }%
  % Define a hook for chapter spacing in listof.. lists.
  \newcommand{\chaptertolists}{%
    \addtocontents{lof}{\protect\ttl@tocsep}%
    \addtocontents{lot}{\protect\ttl@tocsep}%
    \@oc@chaptertolol
    \@oc@chaptertolox
  }%

  % When package titlesec is loaded, assume custom formatting will be done.
  % The \chaptertolists is enabled only when \titleclass is set for \chapter,
  % i.e., \titleclass{\chapter}{top}.
  %
  % When package titlsec is not loaded, add the hook to \@chapter.
  \ifthenelse{\boolean{@oc@titlesecUsed}}\@empty{%
    % Taken from report.cls.
    \def\@chapter[#1]#2{%
      \ifnum \c@secnumdepth >\m@ne
        \refstepcounter{chapter}%
        \typeout{\@chapapp\space\thechapter.}%
        \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
      \else
        \addcontentsline{toc}{chapter}{#1}%
      \fi
      \chaptermark{#1}%
      \chaptertolists% Insert our hook for listof.. lists.
      \if@twocolumn
        \@topnewpage[\@makechapterhead{#2}]%
      \else
        \@makechapterhead{#2}%
        \@afterheading
      \fi
    }%
  }%

  % Let titletoc package handle these listof.. lists.
  \ifthen{\boolean{@oc@titletocUsed}}{%
    \ifthen{\boolean{@oc@listingsUsed}}{%
      \contentsuse{lstlisting}{lol}%
    }%
    \ifthen{\boolean{@oc@fixmeUsed}}{%
      \contentsuse{fixme}{lox}%
    }%
  }%

  % Add table of contents to PDF bookmarks.
  \ifthen{\boolean{@oc@hyperrefUsed}}{%
    \let\@oc@tableofcontents@orig=\tableofcontents
    \renewcommand{\tableofcontents}{%
      \clearpage
      \label{contents}
      \currentpdfbookmark{\contentsname}{contents}
      \@oc@tableofcontents@orig
    }
  }

  % Add list of listings to table of contents.
  \ifthen{\boolean{@oc@listingsUsed}}{%
    \let\@oc@lstlistoflistings@orig=\lstlistoflistings
    \renewcommand{\lstlistoflistings}{%
      \ifthenelse{\isundefined{\chapter}}{%
        \phantomsection
        \label{listings}
        \addcontentsline{toc}{section}{\lstlistlistingname}
      }{%
        \clearpage
        \phantomsection
        \label{listings}
        \addcontentsline{toc}{chapter}{\lstlistlistingname}
      }
      % This command is used internally in \lstlistoflistings.
      % Make sure we don't add the contents label twice (as defined
      % above) twice, set it to the original.
      \let\tableofcontents=\@oc@tableofcontents@orig
      \@oc@lstlistoflistings@orig
    }
  }

  \ifthen{\boolean{@oc@fixmeUsed}}{%
    % Define bookmark level to shut up Hyperref.
    \providecommand*{\toclevel@fixme}{0}%
    % Add list of fixmes to PDF bookmarks.
    \let\@oc@listoffixmes@orig=\listoffixmes
    \renewcommand{\listoffixmes}{%
      \clearpage
      \label{fixmes}
      \currentpdfbookmark{\listfixmename}{fixmes}
      \@oc@listoffixmes@orig
    }
  }

  % Add bibliograpy to table of contents.
  \ifthenelse{\boolean{@oc@natbibUsed}}{%
    \let\@oc@bibsection@orig=\bibsection
    \renewcommand{\bibsection}{%
      \@oc@bibsection@orig
      \ifthenelse{\isundefined{\chapter}}{%
        \addcontentsline{toc}{section}{\refname}
      }{%
        \ifthenelse{\equal{\NAT@sectionbib}{on}}{%
          \addcontentsline{toc}{section}{\bibname}
        }{%
          \addcontentsline{toc}{chapter}{\bibname}
        }
      }
    }
  }{% No natbib.
    \let\@oc@thebibliography@orig=\thebibliography
    \renewcommand{\thebibliography}[1]{%
      \ifthenelse{\isundefined{\chapter}}{%
        \phantomsection
        \addcontentsline{toc}{section}{\refname}
      }{%
        \clearpage
        \phantomsection
        \addcontentsline{toc}{chapter}{\bibname}
      }
      \@oc@thebibliography@orig{#1}
    }
  }
}

