# run-r-on-amls

This is a sample to show how to operationalize R models in Azure Machine Learning Services (AMLS).

If not done yet, you have to setup/configure Azure Machine Learning Services first. See the `configuration.ipynb` notebook for further information.

Once done, you can create a model using the `create_model.r` script.

Finally, use the `run-r-on-amls.ipynb` to deploy the model. The notebook already contains some testing code but to see an example which uses plain REST (from Python), check the `consume-webservice.ipynb`.

Enjoy - and as always: feel free to use but don't blame me if things go wrong ;-)