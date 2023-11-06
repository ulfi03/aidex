import openai
import os
import textract
import PyPDF2

os.environ['REQUESTS_CA_BUNDLE'] = './cert/Corp-Prj-Root-CA.crt'          # for corp proxy
#os.environ['REQUESTS_CA_BUNDLE'] = './cert/Baltimore CyberTrust Root.crt' # for home proxy
openai.api_key = "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"

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
nachrichten = [
    {"role": "system", "content": "Du bist ein Konverter: Du wandelst Fließtexte in Karteikarten um."},
  ]

nachrichten.append({"role": "user", "content": "Die Karteikarten sollen eine knappe Frage haben und die dazugehörige Antwort. Bitte erstelle mindestens 50 unterschiedliche Karteikarten. Erstelle nun Karteikarten auf Grundlage dieses Textes:"+ text})
print("Anfrage wird an Chatbot übergeben")
KarteikartenConverter = openai.ChatCompletion.create(
      model = "gpt-3.5-turbo-16k",
      temperature = 0.3, 
      max_tokens = 2000, 
      messages = nachrichten
    )
print(KarteikartenConverter)
print("This request used " + str(KarteikartenConverter['usage']['total_tokens']) + " tokens.")
print("It used " + str(KarteikartenConverter['usage']['completion_tokens']) + " tokens for completion.")
print("And it used " + str(KarteikartenConverter['usage']['prompt_tokens']) + " tokens for the prompt.")