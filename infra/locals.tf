locals {
    lambdas_path = "${path.module}/../src/lambda"
    external_libs_path = "${path.module}/../src/external_libs"

    python_shell = "${path.module}/../src/python_shell"
    spark = "${path.module}/../src/spark"

    prebuild_folder = "${path.module}/deploy_artifacts/prebuild"

    build_folder = "${path.module}/deploy_artifacts/build"
}