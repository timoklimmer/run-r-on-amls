from azureml.core.model import Model
import rpy2.rinterface
import rpy2.robjects as robjects

def init():
    # init rpy2
    rpy2.rinterface.initr()
    # load model
    model_path = Model.get_model_path('model.RData')
    robjects.r("load('{model_path}')".format(model_path=model_path))
    # run init() function in R (if exists)
    robjects.r("if (exists('init', mode='function')) { init() }")

def run(input_json_string):
    try:
        result_vector = robjects.r(
                "run('{input_json_string}')".format(input_json_string=input_json_string)
            )
        if len(result_vector) > 0:
            return result_vector[0]
        else:
            return ""
    except Exception as e:
        error = str(e)
        return error
