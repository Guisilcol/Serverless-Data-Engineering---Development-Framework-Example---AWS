# Updates all requirements.txt files with the latest dependencies from the conda virtual environments 
source ~/.bashrc

python_shell pigar gen -f src/python_shell/requirements.txt src/python_shell/ --question-answer no
python_lambda pigar gen -f src/lambda/requirements.txt src/lambda/ --question-answer no
python_spark pigar gen -f src/spark/requirements.txt src/spark/ --question-answer no
python_deploy pigar gen -f deploy/requirements.txt deploy/ --question-answer no