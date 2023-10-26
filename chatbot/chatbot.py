import openai
import os



text = "Napoleon Bonaparte, als Kaiser Napoleon I. (französisch Napoléon Bonaparte bzw. Napoléon Ier; * 15. August 1769 in Ajaccio auf Korsika als Napoleone Buonaparte[1]; † 5. Mai 1821 in Longwood House auf St. Helena im Südatlantik), war ein französischer General, Diktator und Kaiser der Franzosen. Aus korsischer Familie stammend, stieg Bonaparte während der Französischen Revolution in der Armee auf. Er erwies sich als ein militärisches Talent ersten Ranges. Vor allem die Feldzüge in Italien und in Ägypten machten ihn populär. Dies ermöglichte ihm, durch den Staatsstreich des 18. Brumaire VIII (9. November 1799), zunächst als einer von drei Konsuln, die Macht in Frankreich zu übernehmen. Von 1799 bis 1804 als Erster Konsul der Französischen Republik und anschließend bis 1814 sowie nochmals 1815 als Kaiser der Franzosen stand er einem diktatorischen Regime mit plebiszitären Elementen vor. Durch verschiedene Reformen – etwa die der Justiz durch den Code civil oder die der Verwaltung – hat Napoleon die staatlichen Strukturen Frankreichs bis in die Gegenwart hinein geprägt und die Schaffung eines modernen Zivilrechts in besetzten europäischen Staaten initiiert. Außenpolitisch errang er, gestützt auf die Armee, zeitweise die Herrschaft über weite Teile Kontinentaleuropas. Er war ab 1805 auch König von Italien und von 1806 bis 1813 Protektor des Rheinbundes und setzte in einigen weiteren Staaten Familienmitglieder und Vertraute als Monarchen ein. Durch die von ihm eingeleitete Auflösung des Heiligen Römischen Reiches 1806 wurde die staatliche Gestaltung Mitteleuropas zu einer zentralen Frage im 19. Jahrhundert. Hatte er anfangs selbst noch den Nationalstaatsgedanken außerhalb Frankreichs verbreitet, erschwerte der Erfolg gerade dieses Gedankens besonders in Spanien, in Deutschland und schließlich auch in Russland die Aufrechterhaltung der napoleonischen Ordnung in Europa. Auf den katastrophalen Ausgang des Feldzugs gegen Russland ab 1812 folgten die Befreiungskriege, die Erschütterung der Vorherrschaft Frankreichs in großen Teilen Europas und letztlich der Sturz Napoleons. Nach einer kurzen Phase der Verbannung auf Elba kehrte er 1815 für hundert Tage an die Macht zurück. In der Schlacht bei Waterloo wurde er endgültig besiegt und bis zu seinem Lebensende auf die Insel St. Helena verbannt."

os.environ['REQUESTS_CA_BUNDLE'] = './cert/Corp-Prj-Root-CA.crt'          # for corp proxy
#os.environ['REQUESTS_CA_BUNDLE'] = './cert/Baltimore CyberTrust Root.crt' # for home proxy
openai.api_key = "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"


nachrichten = [
    {"role": "system", "content": "Du bist ein Konverter: Du wandelst Fließtexte in Karteikarten um. Die Karteikarten sollen eine knappe Frage haben und die dazugehörige Antwort. Wähle die Fragen sowie Antworten nur auf Grundlage des Textes. Pro Frage eine Karteikarte"}
  ]
nachrichten.append({"role": "user", "content": "Wandle folgenden Text in Karteikarten um:"+ text})
KarteikartenConverter = openai.ChatCompletion.create( #with history -> nachrichten ist die history
      model = "gpt-3.5-turbo",
      temperature = 0.2, 
      max_tokens = 500, 
      messages = nachrichten
    )

print(KarteikartenConverter['choices'][0].message.content)
#regExp zum extrahieren der Frage: "Frage:(.*)"m -> Gruppe 1 ([1]-Rückgabe ist eine Array!
#regExp zum extrahieren der Antwort: "Antwort:(.*)"m -> Gruppe 1 ([1]-Rückgabe ist eine Array!)
#regExp zum splitten der Karteikarten: "\n"g -> Achtung! - nur bei jedem dritten auftreten splitten!


while False: #auf true setzten für eine zusätzliche Chatfunktion mit dem Bot
    nutzerEingabe = input("Stelle eine Frage oder formuliere eine Anweisung: ")
    nachrichten.append({"role": "user", "content": nutzerEingabe})

    completion = openai.ChatCompletion.create( #with history
      model = "gpt-3.5-turbo",
      temperature = 0.0, 
      max_tokens = 100, 
      messages = nachrichten
    )
    response = openai.Completion.create( #no history
      model="gpt-3.5-turbo-instruct",
      prompt = nutzerEingabe,
      max_tokens=100,
      temperature=0
    )
    print("with history - "+ completion['choices'][0].message.content)
    print("no history - " + response['choices'][0].text.strip())