MAIN := example
LATEX_DIRS := AOSD Composestar DotNET
STYLE_DIRS := style
GENERAL_OPTIONS := -interaction=nonstopmode
MIKTEX_OPTIONS := -max-print-line=120 -include-directory="./style" -include-directory="./style/contrib"

PDFLATEX := pdflatex
BIBTEX := bibtex
MAKEINDEX := makeindex

ifeq (Windows_NT,$(OS))
os_path_sep := \\
RM := del /F /Q
RM_NULL := 1>NUL 2>NUL || REM
else
os_path_sep := /
RM := rm -f
RM_NULL :=
endif

ifneq (,$(findstring MiKTeX,$(shell $(PDFLATEX) -version)))
tex_options := $(GENERAL_OPTIONS) $(MIKTEX_OPTIONS)
else
ifeq (Windows_NT,$(OS))
tex_inputs_system := $(shell kpsewhich -expand-var=$$TEXINPUTS)
tex_path_sep := ;
else
tex_inputs_system := $(shell kpsewhich -expand-var=\$$TEXINPUTS)
tex_path_sep := :
endif
tex_inputs_latex := $(subst //$(tex_path_sep) ,//$(tex_path_sep),$(foreach dir,$(LATEX_DIRS),./$(dir)//$(tex_path_sep)))
tex_inputs_style := $(subst //$(tex_path_sep) ,//$(tex_path_sep),$(foreach dir,$(STYLE_DIRS),./$(dir)//$(tex_path_sep)))
export TEXINPUTS := .$(tex_path_sep)$(tex_inputs_style)$(tex_inputs_system)$(tex_path_sep)$(tex_inputs_latex)
tex_options := $(GENERAL_OPTIONS)
endif

tex_clean_exts := dvi ps pdf log toc lof lol nlo nls bbl blg ind idx ilg out aux
tex_clean_main_files := $(strip $(foreach ext,$(tex_clean_exts),$(MAIN).$(ext)))
tex_clean_aux_files := $(strip $(foreach dir,$(LATEX_DIRS),$(wildcard $(dir)/*.aux)))

.PHONY: all pdf pdfonce bibonce idxonce clean

all: pdf

pdf: pdfonce bibonce idxonce
	$(PDFLATEX) $(tex_options) $(MAIN)
	$(PDFLATEX) $(tex_options) $(MAIN)
	$(PDFLATEX) $(tex_options) $(MAIN)

pdfonce:
	$(PDFLATEX) $(tex_options) $(MAIN)

bibonce:
	-$(BIBTEX) $(MAIN)

idxonce:
	-$(MAKEINDEX) $(MAIN).nlo -s nomencl.ist -o $(MAIN).nls

clean:
	@-$(RM) $(subst /,$(os_path_sep),$(tex_clean_main_files)) $(RM_NULL)
	@-$(RM) $(subst /,$(os_path_sep),$(tex_clean_aux_files)) $(RM_NULL)

