import openai
import tiktoken
import json

from flask import Flask, request, jsonify
from flask_cors import CORS
import filetype

app = Flask(__name__)
CORS(app, resources={r"/create_index_cards_from_files": {"origins": "*"}, r"/create_index_cards_from_text:": {"origins": "*"}})

@app.route('/create_index_cards_from_files', methods=['POST'])
def create_index_card_from_files():
    file = request.files['file']
    query = json.loads(request.data)['openai_api_key'] 
    uuid = json.loads(request.data)['user_uuid']
    
    file_type = filetype.guess(file)
    if file_type is None:
        return jsonify({'error': 'Unknown file type'})
    if file_type.extension == 'docx':
        
        pass
    elif file_type.extension == 'txt':
        
        pass
    elif file_type.extension == 'pdf':
        
        pass
    else:
        return jsonify({'error': 'Unsupported file type'})
    
        
    return jsonify({'antowrt': 'Hello, World!'})

@app.route('/create_index_cards_from_text', methods=['POST'])
def create_index_card_from_text():
    query = json.loads(request.data)['openai_api_key'] 
    uuid = json.loads(request.data)['user_uuid']
        
    return jsonify({'antowrt': 'Hello, World!'})

def ai_create_index_cards_from_plain_text(plain_text, api_key): 
    nachrichten = [{"role": "system", "content": "Create index cards from plain text."}]
    nachrichten.append({"role": "user", "content": plain_text})
    openai.api_key = api_key

    ai_response = openai.Completion.create(
        model = "gpt-3.5-turbo-0125",
        temperature = 0.7, 
        messages = nachrichten, 
    )
    return ai_response

def get_token_count_for_a_string(string):
    encoding = tiktoken.get_encoding("cl100k_base")
    return len(encoding.encode(string))


if __name__ == "__main__":
    #from waitress import serve
    #serve(app, host="0.0.0.0", port=5000) # for prod
    app.run(debug=True) #for development
   
