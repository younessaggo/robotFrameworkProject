import json
import os


class TokenManager:

    def store_token(self, token_name, token_value, file_path="data/tokens.json"):

        if not os.path.exists(file_path):
            with open(file_path, "w") as f:
                json.dump({}, f)

        try:
            with open(file_path, "r") as f:
                tokens = json.load(f)
        except: json.JSONDecodeError: tokens={}

        tokens[token_name] = token_value

        with open(file_path, "w") as f:
            json.dump(tokens, f)

    def get_token(self,token_name,file_path="data/tokens.json"):
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"File '{file_path}' not found ")

        with open(file_path, "r") as f:
            tokens=json.load(f)

        if token_name in tokens:
            return tokens[token_name]

        else:
            raise KeyError(f"Token '{token_name}' not found in file '{file_path}'")