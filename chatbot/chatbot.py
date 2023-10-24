import openai
import os

os.environ['REQUESTS_CA_BUNDLE'] = './cert/Corp-Prj-Root-CA.crt'
openai.api_key = "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"

completion = openai.ChatCompletion.create(
  model = "gpt-3.5-turbo",
  temperature = 0.1, #kreativität des bots -> eher niedrig halten (er soll nur auf Grundlage
                     #der gegebenen Informationen antworten)
  max_tokens = 50, #maximale Kosten pro Anfrage
  messages = [
    {"role": "system", "content": "hier definieren was die aufgabe des bots ist"},
    #falls Text zu lang, muss dieser auf mehrere Anfragen aufgeteilt werden
    #integration in Bezahlungsmodell-> kostenlos bis x Zeichen, ab x Zeichen zahlungspflichtig
    {"role": "user", "content": "Was ist deine Aufgabe?"}
  ]
)

print(completion.choices[0])