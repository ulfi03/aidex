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

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/create_index_cards_from_files', methods=['POST'])
def create_index_card_from_files():
    #file = request.files['file']
    openai_api_key = json.loads(request.data)['openai_api_key'] 
    uuid = json.loads(request.data)['user_uuid']

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
        responses += ai_response + "#"
    responses = responses[:-1] #remove last # 
    responses = responses.replace("\n", "").split("#") # remove all new lines and split by #
    responses = [item for item in responses if item != ""] #make sure there are no empty strings
    print(responses)
        
    print("Number of Index Cards: " + str(len(responses)) + "\n")
    responses_als_json = [json.loads(item) for item in responses]

    # Access and print the value associated with the key "Frage" for each JSON object
    for frage_und_antwort in responses_als_json:
        print(frage_und_antwort["Frage"] + "\n" + frage_und_antwort["Antwort"] + "\n\n")
    return jsonify({'antwort': 'Hello, World!'})

@app.route('/create_index_cards_from_text', methods=['POST'])
def create_index_card_from_text():
    query = json.loads(request.data)['openai_api_key'] 
    uuid = json.loads(request.data)['user_uuid']
        
    return jsonify({'antwort': 'Hello, World!'})

def ai_create_index_cards_from_plain_text(plain_text, api_key): 
    nachrichten = [{"role": "user", "content": '''Du bist ein Karteikarten-Generator. Du erstellt Karteikarten auf Grundlage von Auschnitten aus 
                Vorlesungsmaterialien, Artikeln, Büchern, etc. Bitte halte dich an folgendes Format: {"Frage": "<hier die Frage>", "Anwort": "<hier die Antwort>"}. Die 
                einzelnen Karteikarten müssen in diesem JSON Format angegeben werden! Gebe Zitate niemals mit "" an (also kein ""<Zitat>"", sondern "<Zitat>")!. Verwende keinerlei Formatierung - keine Zeilumbrüche, Fettschreibung, o.Ä.!! Trenne die Karteikarten mit #!! Bitte 
                erstelle nun die Karteikarten aus dem folgenden Text und halte dich strikt an die Anweisungen: ''' + plain_text}]
    openai.api_key = api_key

    ai_response = openai.chat.completions.create(
        model = "gpt-3.5-turbo",
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
    app.run(debug=True) #for development
    #create_index_card_from_files()
   
