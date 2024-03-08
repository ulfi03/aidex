import openai
import os
import textract
import PyPDF2
import tiktoken

def get_token_count_message(string):
    encoding = tiktoken.get_encoding("cl100k_base")
    return len(encoding.encode(string))

def get_token_count_chat(chatverlauf):
    counter = 0
    for message in chatverlauf:
        counter += get_token_count_message(message["content"])
    return counter

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

openai.api_key = "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"

get_token_count_message(text)
#implement token handling - models context length 16000
#for now just cut
text = text[0:20000]



nachrichten = [
    {"role": "system", "content": 'Du bist ein Konverter: Du wandelst Texte in Karteikarten um. Die Karteikarten sollen eine knappe Frage haben und die dazugehörige Antwort. Wähle die Fragen sowie Antworten nur auf Grundlage des Textes. Pro Frage eine Karteikarte. Folgendes Format: {"Frage": frage, "Antwort": antwort} und anschließend ein # als Separator der einzelnen Karteikarten.'},
  ]
nachrichten.append({"role": "user", "content": "Wandle folgenden Text in Karteikarten um: "+ text})


KarteikartenConverter = openai.chat.completions.create(
      model = "gpt-3.5-turbo-0125",
      temperature = 0.1,  
      messages = nachrichten
    )

ausgabeChatbot = KarteikartenConverter.choices[0].message.content.strip().replace("\n", "").split("#")[:-1]
print(ausgabeChatbot)
