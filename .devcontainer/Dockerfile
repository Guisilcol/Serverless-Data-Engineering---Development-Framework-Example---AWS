FROM amazon/aws-glue-libs:glue_libs_4.0.0_image_01

USER root

RUN groupadd --g 1024 groupcontainer
RUN usermod -a -G groupcontainer glue_user

# Install Terraform
RUN yum install -y yum-utils
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
RUN yum -y install terraform

USER glue_user

# Install pyenv and set up correctly
RUN curl https://pyenv.run | bash \
    && echo -e '\nexport PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo -e '\nexport PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo -e '\neval "$($PYENV_ROOT/bin/pyenv init -)"' >> ~/.bashrc \
    && echo -e '\neval "$($PYENV_ROOT/bin/pyenv virtualenv-init -)"' >> ~/.bashrc

# Add make auto-completion line to bashrc
RUN echo -e '\ncomplete -W "\`grep -oE \'^[a-zA-Z0-9_.-]+:([^=]|$)\' ?akefile | sed \'s/[^a-zA-Z0-9_.-]*$//\'\`" make' >> ~/.bashrc
    
SHELL ["/bin/bash", "-l", "-c"]

# Install Python versions
RUN pyenv install 3.9
RUN pyenv install 3.10
