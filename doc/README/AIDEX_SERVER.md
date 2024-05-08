# AIDEX Server

Overview of the AIDEX server, its functionalities, and key components.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Project Structure](#2-project-structure)
3. [HTTP-Endpoints](#3-HTTP-endpoints)
    - [1. `/create_index_cards_from_files`](#1-create_index_cards_from_files)
    - [2. `/create_index_cards_from_text`](#2-create_index_cards_from_text)
4. [Functions](#4-functions)
    - [1. `extract_text`](#1-extract_text)
    - [2. `schedule_chatgpt_requests`](#2-schedule_chatgpt_requests)
    - [3. `ClientResponse`](#3-clientresponse)
    - [4. `validate_response`](#4-validate_response)
    - [5. `validate_index_card`](#5-validate_index_card)
    - [6. `ai_create_index_cards_from_plain_text`](#6-ai_create_index_cards_from_plain_text)
5. [Constants](#5-constants)

---

## 1. Introduction

AIDEX Server is a Flask-based web application designed to generate index cards from various file types such as PDFs,
DOCX files, and plain text. It leverages OpenAI's GPT-3.5 model to extract relevant information and format it into index
card structures. The server is hosted on [https://aidex-server.onrender.com](https://aidex-server.onrender.com).

## 2. Project Structure

The project structure is hosted on GitHub at [risky-dev-11/aidex_server](https://github.com/risky-dev-11/aidex_server).
It comprises the following two key components:

- `app.py`: Main application file containing Flask routes and server setup.
- `requirements.txt`: Lists dependencies required by the application.

## 3. HTTP-Endpoints

### 1. `/create_index_cards_from_files`

- **Method:** POST
- **Description:** Accepts files uploaded by the user along with an OpenAI API key and user UUID. It extracts text from
  the files, splits it into chunks, and schedules requests to the OpenAI API for index card generation. Currently
  supported file formats are PDF, DOCX, and TXT.
- **Parameters:**
    - `file`: File object containing the document to be processed.
    - `openai_api_key`: OpenAI API key for accessing the GPT-3.5 model.
    - `user_uuid`: Unique identifier for the user. // This variable is currently not used for any functionality
- **Response:** JSON object containing generated index cards or error information.

### 2. `/create_index_cards_from_text`

// This functionality is currently not implemented!

- **Method:** POST
- **Description:** Placeholder endpoint for future functionality to generate index cards directly from text input.
- **Parameters:** None
- **Response:** JSON object with a "Hello World!" response.

## 4. Functions

### 1. `extract_text`

This function retrieves the text from the file, send by the user.

```python
def extract_text(file: FileStorage):
    text = ""
    if file.filename.endswith('.txt'):
        text = file.read().decode('utf-8')
    else:
        # Extracting text from other file formats
    return text
```

### 2. schedule_chatgpt_requests

This function is one of the core elements of the server.

The `schedule_chatgpt_requests` function is designed to process a list of strings concurrently using the OpenAI API.
Here's a detailed breakdown of how it works:

```python
def schedule_chatgpt_requests(str_array, openai_api_key):
```

This function accepts two parameters:

- `str_array`: An array of strings that you want to process.
- `openai_api_key`: Your OpenAI API key.

The function begins by creating a pool of worker threads using `concurrent.futures.ThreadPoolExecutor`. Each thread is
responsible for processing one element from `str_array` by calling the `ai_create_index_cards_from_plain_text` function.

```python
with concurrent.futures.ThreadPoolExecutor() as executor:
    futures = []
    for element in str_array:
        future = executor.submit(ai_create_index_cards_from_plain_text, element, openai_api_key)
        futures.append(future)
```

The `concurrent.futures.as_completed` function is used to iterate over the `Future` instances as they complete (i.e., as
the results become available). If an error occurs during the processing of an element, an exception is raised.

```python
for future in concurrent.futures.as_completed(futures):
    ai_response, error = future.result()
    if error:
        raise Exception(ai_response)
```

The function then validates each response using the `validate_response` function. If the response is valid, it is added
to the `responses` string.

```python
if validate_response(ai_response):
    responses += ai_response + "#"
```

Finally, the function splits the `responses` string into an array of strings, removes any empty strings, and returns the
array of formatted responses.

```python
responses_split = responses.split("#")

formatted_responses = []
for response in responses_split:
    formatted_response = response.strip()
    if formatted_response != "":
        formatted_responses.append(response.strip())

return formatted_responses
```

Python's `concurrent.futures` module significantly improves the response time of our webserver.

### 3. ClientResponse

This is the `ClientResponse` class used to define a general scheme for the client response.

```python
class ClientResponse:
    def __init__(self, index_cards=None, error=False, error_message=''):
        # Constructor implementation

    def to_dict(self):
        # Method implementation
        return {
            'index-cards': self.index_cards,
            'error': self.error,
            'error_message': self.error_message
        }
```

### 4. validate_response

This function validates the chatbots' response.

```python
def validate_response(response):
```

### 5. validate_index_card

This function validates each index card and removes them, if a check fails.

```python
def validate_index_card(json_data):
```

### 6. ai_create_index_cards_from_plain_text

This functionality is currently not implemented!

```python
def ai_create_index_cards_from_plain_text(plain_text, api_key): 
    return generated_index_cards or error_message
```

### 5. Constants

#### QUESTION_LABEL: Constant string representing the label for the question part of an index card.

#### ANSWER_LABEL: Constant string representing the label for the answer part of an index card.
