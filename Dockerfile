ARG BASE_CONTAINER=jupyter/r-notebook-plus

FROM $BASE_CONTAINER

LABEL maintainer="Jun Nishii <nishii@yamaguchi-u.ac.jp>"

USER root
RUN apt-get update && \
   apt-get install -y --no-install-recommends  \
   libcairo2-dev  \
   libxt-dev \
   cargo && \
   rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/local/bin:$PATH
USER $NB_UID

##### install other R libs
RUN conda install --quiet --yes \
    'r-hexbin=1.27*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# cairo requires libcairo2-dev and libxt
RUN R -e "install.packages(c('Cairo'), dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('Rmisc'), dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('testthat'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

RUN R -e "install.packages(c('signal','cowplot','plotly','gganimate'), dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('gifski'), dependencies=TRUE, repos='http://cran.rstudio.com/')"


# Customize jupyter extensions
RUN python -m pip install jupyter-emacskeys
RUN python -m pip install jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --sys-prefix

RUN python -m pip install RISE
RUN jupyter-nbextension install rise --py --sys-prefix

RUN python -m pip install jupytext --upgrade
RUN jupyter nbextension install --py jupytext --sys-prefix
RUN jupyter nbextension enable --py jupytext --sys-prefix

RUN jupyter nbextension enable highlighter/highlighter --sys-prefix
RUN jupyter nbextension enable toggle_all_line_numbers/main --sys-prefix
RUN jupyter nbextension enable hide_header/main --sys-prefix
#RUN jupyter nbextension enable hide_input/main --sys-prefix
RUN jupyter nbextension enable toc2/main --sys-prefix


