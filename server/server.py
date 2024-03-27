import openai
import tiktoken
import json

from flask import Flask, request, jsonify
from flask_cors import CORS

import filetype
from pypdf import PdfReader
import docxpy
import os 
app = Flask(__name__)
CORS(app, resources={r"/create_index_cards_from_files": {"origins": "*"}, r"/create_index_cards_from_text:": {"origins": "*"}})

@app.route('/create_index_cards_from_files', methods=['POST'])
def create_index_card_from_files():
    #file = request.files['file']
    #open_api_key = json.loads(request.data)['openai_api_key'] 
    #uuid = json.loads(request.data)['user_uuid']
    print(os.getcwd())
    open_api_key = "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"
    file = os.getcwd()+'/server/napoleon.pdf'
    file_type = filetype.guess(file)
    if file_type is None:
        return jsonify({'error': 'Unknown file type'})
    if file_type.extension == 'docx':
        text = docxpy.process(file)
        pass
    elif file_type.extension == 'txt':
        with open(file, 'r', encoding='utf-8') as f:
            text = f.read()
        pass
    elif file_type.extension == 'pdf':
        reader = PdfReader(file)
        text = ""
        for page in reader.pages:
            text += page.extract_text() + "\n"
        pass
    else:
        return jsonify({'error': 'Unsupported file type'})
    #Now we have the text from the file
    string_array_of_extracted_text = [text[i:i+5000] for i in range(0, len(text), 5000)]
    for element in string_array_of_extracted_text:
        if get_token_count_for_a_string(element) > 3800:
            return jsonify({'error': 'Critical server error'})
    print("Array of File Content (der Länge - " +  str(len(string_array_of_extracted_text)) + ") validated")
    responses = ""
    for element in string_array_of_extracted_text:
        ai_response = ai_create_index_cards_from_plain_text(element, open_api_key)
        responses += ai_response
    responses = responses.replace("\n", "").replace("\\", "").split("#")
    print("Number of Index Cards: " + str(len(responses)) + "\n")
    responses = ['{"Frage": "Wann wurde Napoleon Bonaparte geboren?", "Antwort": "15. August 1769"}', '{"Frage": "Welche Nationalität hatte Napoleon Bonaparte?", "Antwort": "französisch"}', '{"Frage": "Welches Zitat ist von Napoleon Bonaparte überliefert?", "Antwort": "Man kann keinen Eierkuchen backen, ohne ein paar Eier zu zerschlagen."}', '{"Frage": "Welcher Kämpfer setzte sich für die politische Unabhängigkeit Korsikas ein und war der Sekretär von Napoleons Vater?", "Antwort": "Pascal Paoli"}', '{"Frage": "Wo wurde Napoleon Bonaparte geboren?", "Antwort": "auf der Insel Korsika"}', '{"Frage": "In welchen Fächern punktete Napoleon Bonaparte während seiner schulischen Ausbildung?", "Antwort": "Mathematik und Geschichte"}', '{"Frage": "Wann wurde Napoleon Bonaparte zum General erklärt?", "Antwort": "während der Französischen Revolution"}', '{"Frage": "Wer war die erste Ehefrau von Napoleon Bonaparte?", "Antwort": "Joséphine de Beauharnais"}', '{"Frage": "Wann endete die Französische Revolution mit dem Sturz der Regierung?", "Antwort": "1799"}', '{"Frage": "Wohin wurde Napoleon Bonaparte nach seinem Rücktritt als Kaiser verbannt?", "Antwort": "auf die Insel St. Helena im Südatlantik"}', '{"Frage": "Wann starb Napoleon Bonaparte?", "Antwort": "5. Mai 1821"}', '{"Frage": "Wer war der dritte Napoleon und wie war er mit Napoleon Bonaparte verwandt?", "Antwort": "Charles-Louis-Napoleon Bonaparte, Neffe von Napoleon"}', '{"Frage": "Wo wurde Napoleon Bonaparte geboren?", "Antwort": "Napoleon Bonaparte wurde auf Korsika geboren."}', '{"Frage": "Was tat Napoleon Bonaparte im Jahr 1799 im französischen Parlament?", "Antwort": "Er drang mit einer Gruppe Soldaten ein und gab Frankreich eine neue Verfassung."}', '{"Frage": "Wie krönte sich Napoleon Bonaparte im Jahr 1804?", "Antwort": "Er krönte sich selbst zu „Napoleon dem Ersten, Kaiser der Franzosen“."}', '{"Frage": "Was waren einige der Maßnahmen, die Napoleon Bonaparte als Diktator ergriff?", "Antwort": "Er erließ neue Gesetze, die das Land modernisierten, führte Kriege, machte Frankreich größer und herrschte über andere Länder."}', '{"Frage": "In welcher Schlacht erlitt Napoleon Bonaparte seine endgültige Niederlage?", "Antwort": "Bei der Schlacht bei Waterloo in Belgien."}']
    responses_als_json = [json.loads(item) for item in responses]

    # Access and print the value associated with the key "Frage" for each JSON object
    for frage_und_antwort in responses_als_json:
        print(frage_und_antwort["Frage"] + "\n" + frage_und_antwort["Antwort"] + "\n\n")
    #return jsonify({'antwort': 'Hello, World!'})

@app.route('/create_index_cards_from_text', methods=['POST'])
def create_index_card_from_text():
    query = json.loads(request.data)['openai_api_key'] 
    uuid = json.loads(request.data)['user_uuid']
        
    return jsonify({'antwort': 'Hello, World!'})

def ai_create_index_cards_from_plain_text(plain_text, api_key): 
    nachrichten = [{"role": "user", "content": '''Du bist ein Karteikarten-Generator. Du erstellt Karteikarten auf Grundlage von Auschnitten aus 
                Vorlesungsmaterialien, Artikeln, Büchern, etc. Bitte erstelle möglichst viele Karteikarten. Bitte 
                halte dich an folgendes Format: {"Frage": "<hier die Frage>", "Anwort": "<hier die Antwort>"}. Die 
                einzelnen Karteikarten müssen in diesem JSON Format angegeben werden! Gebe Zitate niemals mit "" an! Weil dann lautet deine Ausgbae ""<Zitat>"". Das darfst du nicht machen! Trenne diese mit #. Bitte 
                erstelle nun die Karteikarten aus dem folgenden Text und halte dich strikt an die Anweisungen: ''' + plain_text}]
    openai.api_key = api_key

    ai_response = openai.ChatCompletion.create(
        model = "gpt-3.5-turbo-0125",
        temperature = 0.7, 
        messages = nachrichten, 
    )
    return ai_response.choices[0].message.content

def get_token_count_for_a_string(string):
    encoding = tiktoken.get_encoding("cl100k_base")
    return len(encoding.encode(string))


if __name__ == "__main__":
    #from waitress import serve
    #serve(app, host="0.0.0.0", port=5000) # for prod
    #app.run(debug=True) #for development
    create_index_card_from_files()
   
