FROM amazon/aws-glue-libs:glue_libs_4.0.0_image_01

USER root

RUN groupadd --g 1024 groupcontainer
RUN usermod -a -G groupcontainer glue_user

# Instalação do Terraform
RUN yum install -y yum-utils
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
RUN yum -y install terraform

USER glue_user

# Instalação do pyenv e inicialização correta
RUN curl https://pyenv.run | bash \
    && echo -e '\nexport PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo -e '\nexport PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo -e '\neval "$($PYENV_ROOT/bin/pyenv init -)"' >> ~/.bashrc \
    && echo -e '\neval "$($PYENV_ROOT/bin/pyenv virtualenv-init -)"' >> ~/.bashrc

SHELL ["/bin/bash", "-l", "-c"]

# Instalação das versões do Python
RUN pyenv install 3.9
RUN pyenv install 3.10


