import sys
import pandas as pd
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix
import seaborn as sns
sns.despine(bottom = True, left = True)
import matplotlib.pyplot as plt
plt.rcParams['font.size'] = 20
import numpy as np

def find_cluster(ids):
    for cluster_list in cluster_lists:
        if ids[0] in cluster_list and ids[1] in cluster_list:
            return 1
    return 0


if __name__ == "__main__":
    gt_file = str(sys.argv[1])
    fo_file = str(sys.argv[2])
    cf_save_path = str(sys.argv[3])
    
    code_ids = []
    labels = []

    with open(gt_file, 'r') as reader:
        for line in reader:
            line = line.strip()
            if line and len(line.split(',')) == 3:
                line = line.split(',')
                label = int(line[2])            
                code_ids.append((int(line[0]), int(line[1])))
                labels.append(label)

    labels = [int(l) for l in labels]
    
    data = pd.read_csv(fo_file)
    
    clusters = {}
    methods_detected_facer = []

    for index, row in data.iterrows():
        if row['clusterID'] in clusters:
            clusters[row['clusterID']].append(row['methodID'])
            methods_detected_facer.append(row['methodID'])
        else:
            clusters[row['clusterID']] = [row['methodID']]
            methods_detected_facer.append(row['methodID'])

    methods_detected_facer = list(set(methods_detected_facer))        
    cluster_lists = []
    for cluster_key in clusters:
        if len(clusters[cluster_key]) > 1:
            cluster_lists.append(clusters[cluster_key])
    
    predictions = []

    for ids in code_ids: 
        prediction = find_cluster(ids)
        predictions.append(prediction)
            
    print('Accuracy:', accuracy_score(labels, predictions))
    print('F1 Score:', f1_score(labels, predictions))
    print('Precision:', precision_score(labels, predictions))
    print('Recall:', recall_score(labels, predictions))
        
    cf = confusion_matrix(labels, predictions, labels=[0, 1])        
    print('Confusion Matrix:\n', cf)
    cf = np.array(cf)

    ax= plt.subplot()

    labels = ['(TN)', '(FP)', '(FN)', '(TP)']

    counts = ['{0:0.0f}'.format(value) for value in
                    cf.flatten()]
    labels = [f'{v1}\n{v2}' for v1, v2 in
              zip(counts,labels)]

    labels = np.asarray(labels).reshape(2,2)
    cf = cf.reshape(2,2)
    fontsize = 22
    sns_plot = sns.heatmap(cf, annot=labels, ax = ax, cmap='gist_gray_r',
                fmt="", linewidths=1, linecolor='black',
                annot_kws={"size": fontsize})
   
    ax.set_xlabel('Predicted Labels', fontsize=fontsize)
    ax.set_ylabel('True Labels', fontsize=fontsize)

    ax.xaxis.set_ticklabels(['Dissimilar', 'Similar'], fontsize=fontsize)
    ax.yaxis.set_ticklabels(['Dissimilar', 'Similar'], fontsize=fontsize, rotation=90, va="center")
    
    fig = sns_plot.get_figure()
    fig.savefig(cf_save_path, bbox_inches='tight', pad_inches=0.3)