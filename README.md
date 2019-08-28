# Run R scoring scripts on Azure Machine Learning Services

This sample shows how to operationalize R models in Azure Machine Learning Services (AMLS).

1. If not done yet, you have to setup/configure Azure Machine Learning Services first. See [here](https://github.com/timoklimmer/setup-machine-for-amls/blob/master/How%20To%20Setup%20Your%20Machine%20for%20Azure%20Machine%20Learning%20Services.ipynb) for details.

2. Once done, you can create a model using the `create_model.r` script, eg. in RStudio or any other IDE you prefer.

3. Finally, use the `create-webservice.ipynb` notebook to create and deploy the webservice with your R model.

4. To see an example using plain REST (from Python), check the `consume-webservice.ipynb`.

Enjoy - and as always: feel free to use but don't blame me if things go wrong ;-)