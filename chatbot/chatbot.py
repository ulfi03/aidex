import openai
import os
import re
import textract
import PyPDF2

#text = "Napoleon Bonaparte, als Kaiser Napoleon I. (französisch Napoléon Bonaparte bzw. Napoléon Ier; * 15. August 1769 in Ajaccio auf Korsika als Napoleone Buonaparte[1]; † 5. Mai 1821 in Longwood House auf St. Helena im Südatlantik), war ein französischer General, Diktator und Kaiser der Franzosen. Aus korsischer Familie stammend, stieg Bonaparte während der Französischen Revolution in der Armee auf. Er erwies sich als ein militärisches Talent ersten Ranges. Vor allem die Feldzüge in Italien und in Ägypten machten ihn populär. Dies ermöglichte ihm, durch den Staatsstreich des 18. Brumaire VIII (9. November 1799), zunächst als einer von drei Konsuln, die Macht in Frankreich zu übernehmen. Von 1799 bis 1804 als Erster Konsul der Französischen Republik und anschließend bis 1814 sowie nochmals 1815 als Kaiser der Franzosen stand er einem diktatorischen Regime mit plebiszitären Elementen vor. Durch verschiedene Reformen – etwa die der Justiz durch den Code civil oder die der Verwaltung – hat Napoleon die staatlichen Strukturen Frankreichs bis in die Gegenwart hinein geprägt und die Schaffung eines modernen Zivilrechts in besetzten europäischen Staaten initiiert. Außenpolitisch errang er, gestützt auf die Armee, zeitweise die Herrschaft über weite Teile Kontinentaleuropas. Er war ab 1805 auch König von Italien und von 1806 bis 1813 Protektor des Rheinbundes und setzte in einigen weiteren Staaten Familienmitglieder und Vertraute als Monarchen ein. Durch die von ihm eingeleitete Auflösung des Heiligen Römischen Reiches 1806 wurde die staatliche Gestaltung Mitteleuropas zu einer zentralen Frage im 19. Jahrhundert. Hatte er anfangs selbst noch den Nationalstaatsgedanken außerhalb Frankreichs verbreitet, erschwerte der Erfolg gerade dieses Gedankens besonders in Spanien, in Deutschland und schließlich auch in Russland die Aufrechterhaltung der napoleonischen Ordnung in Europa. Auf den katastrophalen Ausgang des Feldzugs gegen Russland ab 1812 folgten die Befreiungskriege, die Erschütterung der Vorherrschaft Frankreichs in großen Teilen Europas und letztlich der Sturz Napoleons. Nach einer kurzen Phase der Verbannung auf Elba kehrte er 1815 für hundert Tage an die Macht zurück. In der Schlacht bei Waterloo wurde er endgültig besiegt und bis zu seinem Lebensende auf die Insel St. Helena verbannt."
text = ""
fileNameArray = os.listdir("chatbot/documents")

for (index, item) in enumerate(fileNameArray):
        if item.endswith('.pdf'):
          pdfReader = PyPDF2.PdfReader(open("chatbot/documents/" + item, 'rb'))
          for pageNum in range(len(pdfReader.pages)):
            text = text + pdfReader.pages[pageNum].extract_text()
        else:
          text = text + str(textract.process("chatbot/documents/" + item, encoding="utf-8"))
        print(item + " wurde eingelesen")
print (text)

os.environ['REQUESTS_CA_BUNDLE'] = './cert/Corp-Prj-Root-CA.crt'          # for corp proxy
#os.environ['REQUESTS_CA_BUNDLE'] = './cert/Baltimore CyberTrust Root.crt' # for home proxy
openai.api_key = "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"


nachrichten = [
    {"role": "system", "content": "Du bist ein Konverter: Du wandelst Fließtexte in Karteikarten um. Die Karteikarten sollen eine knappe Frage haben und die dazugehörige Antwort. Wähle die Fragen sowie Antworten nur auf Grundlage des Textes. Pro Frage eine Karteikarte. Folgendes Format: Frage: ...  Antwort: ... und anschließend ein # als Separator."},
  ]
nachrichten.append({"role": "user", "content": "Wandle folgenden Text in Karteikarten (Format - Frage:... Antwort:...#. Die Frage soll auch wirklich eine Frage sein und die Antwort die Antwort auf entsprechende Frage) um:"+ text})
print("Anfrage wird an Chatbot übergeben")
KarteikartenConverter = openai.ChatCompletion.create( #with history -> nachrichten ist die history
      model = "gpt-3.5-turbo",
      temperature = 0.2, 
      max_tokens = 1000, 
      messages = nachrichten
    )
ausgabeChatbot = KarteikartenConverter['choices'][0].message.content.split("#")
#ausgabeChatbot = ['Frage: Wo wurde Napoleon Bonaparte geboren?\nAntwort: Napoleon Bonaparte wurde in Ajaccio auf Korsika geboren.', '\n\nFrage: Welche Position hatte Napoleon Bonaparte während der Französischen Revolution inne?\nAntwort: Napoleon Bonaparte stieg während der Französischen Revolution in der Armee auf.', '\n\nFrage: Welche Feldzüge machten Napoleon Bonaparte populär?\nAntwort: Die Feldzüge in Italien und in Ägypten machten Napoleon Bonaparte populär.', '\n\nFrage: Wann übernahm Napoleon Bonaparte die Macht in Frankreich?\nAntwort: Napoleon Bonaparte übernahm am 9. November 1799 durch den Staatsstreich des 18. Brumaire VIII die Macht in Frankreich.', '\n\nFrage: Welche Reformen hat Napoleon Bonaparte in Frankreich durchgeführt?\nAntwort: Napoleon Bonaparte hat unter anderem Reformen in der Justiz durch den Code civil und in der Verwaltung durchgeführt.', '\n\nFrage: Welche Position hatte Napoleon Bonaparte von 1799 bis 1814 inne?\nAntwort: Von 1799 bis 1814 war Napoleon Bonaparte Kaiser der Franzosen.', '\n\nFrage: Welche Auswirkungen hatte die Auflösung des Heiligen Römischen Reiches durch Napoleon Bonaparte?\nAntwort: Die Auflösung des Heiligen Römischen Reiches im Jahr 1806 hatte eine zentrale Fragestellung in der staatlichen Gestaltung Mitteleuropas im 19. Jahrhundert zur Folge.', '\n\nFrage: Was folgte auf den Feldzug gegen Russland ab 1812?\nAntwort: Auf den Feldzug gegen Russland ab 1812 folgten die Befreiungskriege und die Erschütterung der Vorherrschaft Frankreichs in großen Teilen Europas.', '\n\nFrage: Wo wurde Napoleon Bonaparte nach seiner endgültigen Niederlage verbannt?\nAntwort: Napoleon Bonaparte wurde bis zu seinem Lebensende auf die Insel St. Helena verbannt.', '']
formatierteAusgabe = []
"""
for (index, item) in enumerate(ausgabeChatbot):
    if "Frage:" and "Antwort:" in item:
      frage = re.search("Frage:(.*)", item)[1]
      antwort = re.search("Antwort:(.*)", item)[1]
      formatierteAusgabe.append({frage, antwort})
"""
print(formatierteAusgabe)
print(ausgabeChatbot)

while True: #auf true setzten für eine zusätzliche Chatfunktion mit dem Bot
    nutzerEingabe = input("Stelle eine Frage oder formuliere eine Anweisung: ")
    nachrichten.append({"role": "user", "content": nutzerEingabe})

    completion = openai.ChatCompletion.create( #with history
      model = "gpt-3.5-turbo",
      temperature = 0.2, 
      max_tokens = 100, 
      messages = nachrichten
    )
    print(completion['choices'][0].message.content)
    """
    response = openai.Completion.create( #no history
      model="gpt-3.5-turbo-instruct",
      prompt = nutzerEingabe,
      max_tokens=100,
      temperature=0
    )
    """
    #print("no history - " + response['choices'][0].text.strip())