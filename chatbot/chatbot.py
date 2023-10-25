import openai
import os

#os.environ['REQUESTS_CA_BUNDLE'] = './cert/Corp-Prj-Root-CA.crt'          # for corp proxy
os.environ['REQUESTS_CA_BUNDLE'] = './cert/Baltimore CyberTrust Root.crt' # for home proxy
openai.api_key = "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"

nachrichten = [
    {"role": "system", "content": "Du wandelst Fließtexte in Karteikarten um"}
  ]

nutzerEingabe = input("Stelle eine Frage: ")
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

print(completion['choices'][0].message.content)
print(response['choices'][0].text)