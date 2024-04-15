# Problematica e objetivos

Quando estamos trabalhando em um projeto de engenharia de dados temos disponíveis um leque enorme de ferramentas que podem atender as nossas necessidades. No caso da AWS, quando o assunto é processamento de dados, temos alguns serviços interessantes que podem ser utilizados: AWS Lambda, AWS Glue, AWS EMR etc. Muitas vezes, por um questão de custo, a arquitetura utilizada é baseada em uma mescla de todos esses serviços. Geralmente (não é uma regra), no desenvolvimento de pipelines, utilizamos AWS Lambda em processos simples, rápidos, que não demandam muitos recursos computacionais e não tendem a crescer. Quando o processo em questão não atendem esses requisitos, utilizamos AWS Glue com Python Shell Jobs. Caso esse processo possua uma volumetria muito grande ou tenda a crescer muito a ponto de necessitar de uma tecnologia para processamento distribuido, utilizamos Spark Jobs. Agora, caso tenhamos processos que demandem MUITO poder computacional (em especial processos de Big Data), utilizamos AWS EMR.

O maior problema que enfrentamos ao utilizar essa arquitetura é a forma que o desenvolvimento é feito. Cada serviço possui uma forma diferente de desenvolvimento, o que acaba por dificultar a manutenção do código. Funções Lambda possuem um padrão específico de desenvolvimento, que por sua vez é diferente um Python Shell Job do AWS Glue etc. Manter diversos ambientes de desenvolvimento para cada serviço é complexo e demanda muito tempo: imagine que você tenha um pipeline destinado a carregar um Data Mart: foram usadas algumas funções Lambda, Python Shell's. Dependendo da forma que você desenvolveu o pipeline, a pipeline terá pelo menos 3 ambientes de desenvolvimento diferentes (isso sem contar na dificuldade de fazer o deploy de cada serviço caso você não tenha um CI/CD bem estruturado). 

# Objetivos 

O objetivo desse projeto é criar um framework que permita o desenvolvimento de pipelines de dados de forma simples, rápida e padronizada que abranja os serviços da AWS destinados a processamento de dados, unificando o desenvolvimento de pipelines em um só repositório, assim como facilitar o deploy dos serviços. Para isso, utilizaremos uma estrutura de pastas que permita a separação de cada serviço, assim como ter um Dev Container que possua ambientes Python que atendam as necessidades de cada serviço. Para tal, utilizaremos o Docker para subir um container que, utilizando Conda, possua todos os ambientes necessários para cada serviço. Para atender o deploy, utilizaremos um script que permita o deploy de todos os serviços de forma simples e rápida utilizando o módulo boto3.

## Funções Lambda 

Todo arquivo presente na pasta `src/lambda` será considerado uma função Lambda. O arquivo deve conter uma função chamada `handler` que será a função que será chamada pela AWS Lambda. Dentro da pasta `src/lambda/internal_libs` devem ser escritos módulos que serão utilizados pelas funções Lambda, isto é, código compartilhado. Esses módulos serão tratados na AWS como Layers. A princípio, cada função poderá ter atrelada de uma a 2 layers: uma correspondente ao código da pasta internal_libs e outra correspondente a uma layer de dependências externas (qualquer dependência instalada com pip install, por exemplo).

O deploy é feito da seguinte forma:

- Quando algo da pasta `internal_libs` é alterado, a layer correspondente a esse código-fonte é atualizada. 
- Duas layers serão destinadas para armazenar as dependências externas do código-fonte presente na pasta `internal_libs`, totalizando 100MBs. 
- Duas layers serão destinadas para armazenar as dependências externas do código-fonte da função Lambda, totalizando 100MBs. Essas layers são de uso exclusivo da função Lambda em questão.
- Qualquer arquivo .py presente na pasta `src/lambda` será considerado uma função Lambda, portanto, ao criar ou alterar um arquivo .py, a função Lambda correspondente será criada ou atualizada.

## AWS Glue (Python Shell)

