# IR_Homework1

Andrea Bugin 1180044

Repository contenente tutti i file e i risultati ottenuti nell'homework 1 del corso di Information Retrieval.

Nella cartella "Risultati" ci sono i risultati ottenuti nelle varie Run:
nei file .txt ci sono tutte le misure calcolate ottenute utilizzando il comando:
  sh bin/trec_eval.sh -q -m all_trec qrels.trec7.txt var/results/BM25b0.75_0.res
e l'output è stato salvato in un file .txt.
I file  
- BM25b0.75_0.* fanno riferimento alla run con Stoplist, Porter stemmer, BM25 = Run 1
- TF_IDF_1.* fanno riferimento alla run con Stoplist, Porter stemmer, TF*IDF = Run 2
- BM25b0.75_2.* fanno riferimento alla run con No stoplist, Porter Stemmer, BM25 = Run 3
- TF_IDF_3.* fanno riferimento alla run con No stoplist, No stemmer, TF*IDF = Run 4
All'interno c'è anche la cartella "Ignore_low_idf" che contiene i risultati delle quattro run dove nel file terrier.properties è stato inserito anche il parametro ignore.low.idf.terms=true come spiegato nella relazione.


Nella cartella "ANOVA" sono presenti:
- i tre file .m che calcolano i risultati del test ANOVA per le varie misure, stampando la tabella ANOVA, la tabella di comparazione multipla e i tre grafici della distribuzione, dei boxplot e dei topgroup (il file ANOVA_AP si riferisce alla Average Precision e i nomi degli altri file di conseguenza);
- i nove file .pdf che sono i grafici salvati quando sono stati stampati in matlab; come scritto nella relazione questi file hanno una risoluzione maggiore in modo da consultarli più facilmente.
- i quattro file .txt prodotti come descritto nella cartella "Risultati"
- il file Parser.java che converte i risultati salvati nei file .txt e li stampa in modo da ottenere i vettori dei valori per topic da inserire direttamente in MatLab. Il parser accetta anche più file alla volta e chiede di quale misura si voglia stampare il vettore (NOTA: accetta solo una misura per volta ed è case sensitive). Un esempio di utilizzo:

java Parser BM25b0.75_0.txt TF_IDF_1.txt BM25b0.75_2.txt TF_IDF_3.txt

Dopo aver immesso il nome di una misura (esempio: map) stamperà i vettori in base all'ordine con cui sono stati passati i file di input.
