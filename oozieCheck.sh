workPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
python vizoozie/vizoozie.py $workPath/workflowPlace/workflow.xml $workPath/workflowPlace/workflow.dot
dot -Tpdf $workPath/workflowPlace/workflow.dot -o $workPath/workflowPlace/workflow.pdf
rm $workPath/workflowPlace/workflow.dot
