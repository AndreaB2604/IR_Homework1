/** 
  * INFORMATION RETRIEVAL HOMEWORK 1
  *
  * Classe Parser
  * Classe per ordinare per topic crescente i valori di una misura all'interno di uno o più file restituiti da trec_eval.
  * Restituisce una stampa degli array di valori da poter immediatamente copiare su Matlab per i test ANOVA.
  *
  * @author A. Bugin
  * @version 28-12-18
  */


import java.io.*;
import java.util.*;

public class Parser
{
	public static void main(String[] args)
	{
		FileReader fr = null;
		int len = args.length;
		if(len < 1)
		{
			System.out.println("Usa: java Parser \"file_da_parsare\"");
			System.out.println("Esempio: java Parser <file1.txt> <file2.txt> ...");
			System.exit(0);
		}
		
		Scanner in = new Scanner(System.in);
		System.out.println("Scrivere la misura di cui fare il parsing (es: map, Rprec, ...)");
		String param = in.nextLine();
		
		for(int i=0; i<len; i++)
		{
			try
			{
				fr = new FileReader(args[i]);
			}
			catch(FileNotFoundException fnfe)
			{
				fnfe.printStackTrace();
				continue;
			}
			Scanner s = new Scanner(fr);
			
			ArrayList<String> al = new ArrayList<String>();
			
			while(s.hasNextLine())
			{
				String line = s.nextLine();
				Scanner sl = new Scanner(line);
				
				String measure = sl.next();
				String topic = sl.next();
				String value = sl.next();
				
				if(measure.compareTo(param) == 0 && topic.compareTo("all") != 0)
				{
					//System.out.println(value);
					al.add(value);
				}
				sl.close();
			}
			String[] tmp = new String[al.size()]; 
			al.toArray(tmp);
			System.out.println(Arrays.toString(tmp));
			
			s.close();
		}
		
		try
		{
			fr.close();
		}
		catch(IOException ioe)
		{
			ioe.printStackTrace();
			System.exit(1);
		}
	}
}