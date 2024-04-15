FROM amazon/aws-glue-libs:glue_libs_4.0.0_image_01

USER glue_user

# Install Conda 
RUN mkdir -p ~/miniconda3 \
&& wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh \
&& bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 \
&& rm -rf ~/miniconda3/miniconda.sh

# Creating the glue_python_shell conda enviroment
RUN ~/miniconda3/bin/conda create -n glue_python_shell_env python=3.9

# Creating the lambda conda enviroment
RUN ~/miniconda3/bin/conda create -n lambda_env python=3.10

# Creating the glue_spark conda enviroment
RUN ~/miniconda3/bin/conda create -n glue_spark_env python=3.10 

# Creating the python_deploy conda enviroment
RUN ~/miniconda3/bin/conda create -n python_deploy_env python=3.10 

# Creates Alias for the conda bin and enviroments 
RUN echo -e '\nalias conda=~/miniconda3/bin/conda' >> ~/.bashrc
RUN echo -e '\nalias python_shell="~/miniconda3/bin/conda run -n glue_python_shell_env"' >> ~/.bashrc
RUN echo -e '\nalias python_lambda="~/miniconda3/bin/conda run -n lambda_env"' >> ~/.bashrc
RUN echo -e '\nalias python_spark="~/miniconda3/bin/conda run -n glue_spark_env"' >> ~/.bashrc
RUN echo -e '\nalias python_deploy="~/miniconda3/bin/conda run -n python_deploy_env"' >> ~/.bashrc

# Install the required packages for python_shell
COPY src/python_shell/requirements.txt /tmp/requirements.txt
RUN ~/miniconda3/bin/conda run -n glue_python_shell_env pip install -r /tmp/requirements.txt

# Install the required packages for python_lambda
COPY src/lambda/requirements.txt /tmp/requirements.txt
RUN ~/miniconda3/bin/conda run -n lambda_env pip install -r /tmp/requirements.txt

# Install the required packages for python_spark
COPY src/spark/requirements.txt /tmp/requirements.txt
RUN ~/miniconda3/bin/conda run -n glue_spark_env pip install -r /tmp/requirements.txt

# Install the required packages for python_deploy
COPY deploy/requirements.txt /tmp/requirements.txt
RUN ~/miniconda3/bin/conda run -n python_deploy_env pip install -r /tmp/requirements.txt

# Install pigar in all enviroments
RUN ~/miniconda3/bin/conda run -n glue_python_shell_env pip install pigar
RUN ~/miniconda3/bin/conda run -n lambda_env pip install pigar
RUN ~/miniconda3/bin/conda run -n glue_spark_env pip install pigar
RUN ~/miniconda3/bin/conda run -n python_deploy_env pip install pigar