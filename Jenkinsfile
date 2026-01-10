@Library('Jenkins-shared-library') _

def configMap = [
    project : "safety"
    component : "catalogue"
    ]

// if branch is not equals to main, then run CI pipeline
if (! env.BRANCH_NAME.equalsIgnoreCase('main') ) {
     nodeJSEKSPipeline(configMap)
}
else {
    echo "please follow CR Process"
}