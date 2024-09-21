import socketserver
import json
import hashlib
import secrets
import html
import os
from util.request import Request
from util.auth import extract_credentials
from util.auth import validate_password
from util.multipart import parse_multipart
from util.websockets import compute_accept
from util.websockets import parse_ws_frame
from util.websockets import generate_ws_frame
from pymongo import MongoClient 
mongo_client = MongoClient("mongo") 
db = mongo_client["cse312"] 
chat_collection = db["chat"]
id_collection = db["ID"]

# use ctrl + f find Security 13 & Security 14 and check it
# use ctrl + f find "large TCP buffer" Check the submitted code to ensure a very large TCP buffer was not used
# use mongoDB, no Security 18 requirement

def getLastMessageID():
    res = 0
    last_record = chat_collection.find().sort({'_id':-1}).limit(1)
    listfyCursor = list(last_record)
    if len(listfyCursor) > 0:
        last_document = listfyCursor[0]
        specific_value = last_document['id']
        return int(specific_value)
    return 0 

# docker compose up --build --force-recreate 

class MyTCPHandler(socketserver.BaseRequestHandler):
    
    clients = []
    auth_user = {}

    def handle(self):

        received_data = self.request.recv(2048)
        print(self.client_address)
        print("--- received data ---")
        print(received_data)
        print("--- end of data ---\n\n")
        request = Request(received_data)

        # TODO: Parse the HTTP request and use self.request.sendall(response) to send your response
        if "/.." in request.path:
            body = '404 not found'
            message_content = bytes(body, 'utf-8')
            content_length = len(message_content)
            string_response = 'HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
            response = bytes(string_response, 'utf-8') + message_content
            self.request.sendall(response)
        
        if request.path == '/':
            with open('public/index.html', 'r') as f:
                html_string = f.read()
            if request.cookies:
                if 'visits' in request.cookies:
                    visits_value = str(int(request.cookies['visits']) + 1)
                    html_string = html_string.replace('{{visits}}',visits_value)
                    html_content = bytes(html_string, 'utf-8')
                    content_length = len(html_content)
                    string_response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\nSet-Cookie: visits = {}; Max-Age = 3600\r\n\r\n'.format(content_length, visits_value)
                    response = bytes(string_response, 'utf-8') + html_content
                else:
                    visits_value = '1'
                    html_string = html_string.replace('{{visits}}',visits_value)
                    html_content = bytes(html_string, 'utf-8')
                    content_length = len(html_content)
                    string_response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\nSet-Cookie: visits = {}; Max-Age = 3600\r\n\r\n'.format(content_length, visits_value)
                    response = bytes(string_response, 'utf-8') + html_content

                if 'auth_token' in request.cookies:
                    
                    hashed_token_body = hashlib.sha256((request.cookies['auth_token']).encode('utf-8')).hexdigest()
                    hashed_token = bytes(hashed_token_body, 'utf-8')
                    cursor_id = id_collection.find({"token": hashed_token})
                    listfyCursor_id = list(cursor_id)
                    if len(listfyCursor_id) != 0:
                        string_to_replace = 'Register:\n        <form action="/register" method="post" enctype="application/x-www-form-urlencoded">\n            <label>Username:\n                <input id="reg-form-username" type="text" name="username_reg"/>\n            </label>\n            <br/>\n            <label>Password:&nbsp;\n                <input id="reg-form-pass" type="password" name="password_reg">\n            </label>\n            <input type="submit" value="Post">\n        </form>\n\n        Login:\n        <form action="/login" method="post" enctype="application/x-www-form-urlencoded">\n            <label>Username:\n                <input id="login-form-username" type="text" name="username_login"/>\n            </label>\n            <br/>\n            <label>Password:&nbsp;\n                <input id="login-form-pass" type="password" name="password_login">\n            </label>\n            <input type="submit" value="Post">\n'
                        fill_in_string = '<form action="/logout" method="post" enctype="application/x-www-form-urlencoded">\n<input type="submit" value="Log out">\n</form>\n' +\
                            '<div id="logedin-users"><h1>User List:</h1></div>'
                        html_string = html_string.replace(string_to_replace,fill_in_string)

                        id_db_user_Info = listfyCursor_id[0]
                        if  id_db_user_Info['XSRF_Token'] == None:
                            new_XSRF_Token = secrets.token_hex(32) 
                            filter = { 'user_name_registed': id_db_user_Info['user_name_registed'] }
                            updated_value = { "$set": { 'XSRF_Token': new_XSRF_Token} }
                            id_collection.update_one(filter, updated_value)
                            string_to_replace = '<input id="chat-text-box" type="text">\n'
                            fill_in_string = '<input id="chat-text-box" type="text">\n                <input value="{}" id="xsrf_token" hidden> </input>\n                '.format(new_XSRF_Token)
                            html_string = html_string.replace(string_to_replace,fill_in_string)
                            
                            # string_to_replace = '<input id="post-pic" type="file" name="upload">\n'
                            # fill_in_string = '<input id="post-pic" type="file" name="upload">\n                <input value="{}" id="xsrf_token" hidden> </input>\n                '.format(new_XSRF_Token)
                            # html_string = html_string.replace(string_to_replace,fill_in_string)
                            
                        else:
                            string_to_replace = '<input id="chat-text-box" type="text">\n'
                            fill_in_string = '<input id="chat-text-box" type="text">\n                <input value="{}" id="xsrf_token" hidden> </input>\n                '.format(id_db_user_Info['XSRF_Token'])
                            html_string = html_string.replace(string_to_replace,fill_in_string)
                            
                            # string_to_replace = '<input id="post-pic" type="file" name="upload">\n'
                            # fill_in_string = '<input id="post-pic" type="file" name="upload">\n                <input value="{}" id="xsrf_token" hidden> </input>\n                '.format(id_db_user_Info['XSRF_Token'])
                            # html_string = html_string.replace(string_to_replace,fill_in_string)


                    html_content = bytes(html_string, 'utf-8')
                    content_length = len(html_content)
                    string_response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\nSet-Cookie: visits = {}; Max-Age = 3600\r\n\r\n'.format(content_length, visits_value)
                    response = bytes(string_response, 'utf-8') + html_content
                    
            else:
                visits_value = '1'
                html_string = html_string.replace('{{visits}}',visits_value)
                html_content = bytes(html_string, 'utf-8')
                content_length = len(html_content)
                string_response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\nSet-Cookie: visits = {}; Max-Age = 3600\r\n\r\n'.format(content_length, visits_value)
                response = bytes(string_response, 'utf-8') + html_content
            self.request.sendall(response)
        elif request.path.split('/')[1] == 'chat-messages':
            if request.method == 'GET':
                if len(request.path.split('/')) == 2:
                    cursor = chat_collection.find({})
                    body = json.dumps(list(cursor),default=str)
                    message_content = bytes(body, 'utf-8')
                    content_length = len(message_content)
                    string_response = 'HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                    response = bytes(string_response, 'utf-8') + message_content
                    self.request.sendall(response)
                else:
                    id = request.path.split('/')[2]
                    cursor = chat_collection.find({"id": id})
                    listfyCursor = list(cursor)
                    if len(listfyCursor) == 0:
                        body = '404 not found'
                        message_content = bytes(body, 'utf-8')
                        content_length = len(message_content)
                        string_response = 'HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                        response = bytes(string_response, 'utf-8') + message_content
                        self.request.sendall(response)
                    else:
                        body = json.dumps(listfyCursor[0],default=str)
                        message_content = bytes(body, 'utf-8')
                        content_length = len(message_content)
                        string_response = 'HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                        response = bytes(string_response, 'utf-8') + message_content
                        self.request.sendall(response)
            elif request.method == 'POST':
                id = getLastMessageID() + 1
                raw_message = json.loads(request.body)['message']
                message = html.escape(raw_message)
                username = "Guest"
                if 'auth_token' in request.cookies:
                    hashed_token_body = hashlib.sha256((request.cookies['auth_token']).encode('utf-8')).hexdigest()
                    hashed_token = bytes(hashed_token_body, 'utf-8')
                    cursor = id_collection.find({"token": hashed_token})
                    listfyCursor = list(cursor)
                    if len(listfyCursor) != 0:
                        id_db_user_Info = listfyCursor[0]
                        username = id_db_user_Info['user_name_registed']

                        token_from_body = json.loads(request.body)['xsrf_token']
                        if  id_db_user_Info['XSRF_Token'] == token_from_body:
                            chat_collection.insert_one({"message": message, "username": username, "id": str(id),"messageType": 'chatMessage'})
                            body = json.dumps({"message": message, "username": username, "id":str(id)})
                            message_content = bytes(body, 'utf-8')
                            content_length = len(message_content)
                            string_response = 'HTTP/1.1 201 Created\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                            response = bytes(string_response, 'utf-8') + message_content
                            self.request.sendall(response)
                        else:
                            body = '403 Forbidden Invalid XSRF_Token'
                            message_content = bytes(body, 'utf-8')
                            content_length = len(message_content)
                            string_response = 'HTTP/1.1 403 Forbidden\r\nContent-Type: text/plain\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                            response = bytes(string_response, 'utf-8') + message_content
                            self.request.sendall(response)
                    else:
                        chat_collection.insert_one({"message": message, "username": username, "id": str(id),"messageType": 'chatMessage'})
                        body = json.dumps({"message": message, "username": username, "id":str(id),"messageType": 'chatMessage'})
                        message_content = bytes(body, 'utf-8')
                        content_length = len(message_content)
                        string_response = 'HTTP/1.1 201 Created\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                        response = bytes(string_response, 'utf-8') + message_content
                        self.request.sendall(response)

                else:
                    chat_collection.insert_one({"message": message, "username": username, "id": str(id),"messageType": 'chatMessage'})
                    body = json.dumps({"message": message, "username": username, "id":str(id),"messageType": 'chatMessage'})
                    message_content = bytes(body, 'utf-8')
                    content_length = len(message_content)
                    string_response = 'HTTP/1.1 201 Created\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                    response = bytes(string_response, 'utf-8') + message_content
                    self.request.sendall(response)
            elif request.method == 'DELETE':
                id = request.path.split('/')[2]
                cursor = chat_collection.find({"id": id})
                listfyCursor = list(cursor)
                if len(listfyCursor) == 0:
                    body = '404 not found'
                    message_content = bytes(body, 'utf-8')
                    content_length = len(message_content)
                    string_response = 'HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                    response = bytes(string_response, 'utf-8') + message_content
                    self.request.sendall(response)
                else:
                    if 'auth_token' in request.cookies:
                        hashed_token_body = hashlib.sha256((request.cookies['auth_token']).encode('utf-8')).hexdigest()
                        hashed_token = bytes(hashed_token_body, 'utf-8')
                        cursor_id = id_collection.find({"token": hashed_token})
                        listfyCursor_id = list(cursor_id)
                        if len(listfyCursor_id) != 0:
                            id_db_user_Info = listfyCursor_id[0]
                            username_id = id_db_user_Info['user_name_registed']
                            chat_db_user_Info = listfyCursor[0]
                            username_chat = chat_db_user_Info['username']
                            if username_chat == username_id:
                                chat_collection.delete_one({"id": id})
                                string_response = 'HTTP/1.1 204 No Content\r\nX-Content-Type-Options: nosniff\r\n\r\n'
                                response = bytes(string_response, 'utf-8')
                                self.request.sendall(response)
                            else:
                                string_response = 'HTTP/1.1 403 Forbidden\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(0)
                                response = bytes(string_response, 'utf-8')
                                self.request.sendall(response)

            elif request.method == 'PUT':
                id = request.path.split('/')[2]
                cursor = chat_collection.find({"id": id})
                listfyCursor = list(cursor)
                if len(listfyCursor) == 0:
                    body = '404 not found'
                    message_content = bytes(body, 'utf-8')
                    content_length = len(message_content)
                    string_response = 'HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                    response = bytes(string_response, 'utf-8') + message_content
                    self.request.sendall(response)
                else:
                    raw_message = json.loads(request.body)['message']
                    message = html.escape(raw_message)

                    filter = { 'id': id }
                    updated_value = { "$set": { 'message': message, "username": json.loads(request.body)['username']} }
                    chat_collection.update_one(filter, updated_value)
                    body = json.dumps({"message": message, "username": json.loads(request.body)['username'], "id":id})
                    message_content = bytes(body, 'utf-8')
                    content_length = len(message_content)
                    string_response = 'HTTP/1.1 200 OK\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                    response = bytes(string_response, 'utf-8') + message_content
                    self.request.sendall(response)

        elif request.path.split('/')[1] == 'register':
            if request.method == 'POST':
                credential = extract_credentials(request)
                cursor = id_collection.find({"user_name_registed": credential[0]})
                listfyCursor = list(cursor)
                if len(listfyCursor) != 0:
                    # body = 'Your username has taken.'
                    # message_content = bytes(body, 'utf-8')
                    # content_length = len(message_content)
                    string_response = 'HTTP/1.1 302 Found\r\nContent-Length: {}\r\nLocation: http://localhost:8080/ \r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(0)
                    response = bytes(string_response, 'utf-8')
                    self.request.sendall(response)
                else:
                    
                    #--------Security 13

                    if validate_password(credential[1]):
                        salt = secrets.token_hex(8) 
                        hashed_password_body = hashlib.sha256((credential[1] + salt).encode('utf-8')).hexdigest()
                        hashed_password = bytes(hashed_password_body, 'utf-8')
                        salt_byte = bytes(salt, 'utf-8')
                        id_collection.insert_one({"user_name_registed": credential[0], "hashed_password": hashed_password, "salt": salt_byte, "token": None, "XSRF_Token": None})
                        string_response = 'HTTP/1.1 302 Found\r\nContent-Length: 0\r\nLocation: http://localhost:8080/ \r\nX-Content-Type-Options: nosniff\r\n\r\n'
                        response = bytes(string_response, 'utf-8')
                        self.request.sendall(response)
                    else:
                        # body = 'Invalid password, please make your password contain: one numeric character one uppercase character one lowercase character ! @ # $ % ^ & , - _ = any of these characters and all your password characters need to be at least 8 characters in total.'
                        # message_content = bytes(body, 'utf-8')
                        # content_length = len(message_content)
                        string_response = 'HTTP/1.1 302 Found\r\nContent-Length: 0\r\nLocation: http://localhost:8080/ \r\nX-Content-Type-Options: nosniff\r\n\r\n'
                        response = bytes(string_response, 'utf-8')
                        self.request.sendall(response)

                    #--------Security 13

        elif request.path.split('/')[1] == 'login':
            if request.method == 'POST':
                credential = extract_credentials(request)
                cursor = id_collection.find({"user_name_registed": credential[0]})
                listfyCursor = list(cursor)
                if len(listfyCursor) == 0:
                    # body = 'Username dose not exist.'
                    # message_content = bytes(body, 'utf-8')
                    # content_length = len(message_content)
                    string_response = 'HTTP/1.1 302 Found\r\nContent-Length: 0\r\nLocation: http://localhost:8080/ \r\nX-Content-Type-Options: nosniff\r\n\r\n'
                    response = bytes(string_response, 'utf-8')
                    self.request.sendall(response)
                else:

# Security 14

                    id_db_user_Info = listfyCursor[0]
                    salt = id_db_user_Info['salt']
                    decode_salt = salt.decode("utf-8")
                    hashed_password_body = hashlib.sha256((credential[1] + decode_salt).encode('utf-8')).hexdigest()
                    hashed_password = bytes(hashed_password_body, 'utf-8')
                    if hashed_password == id_db_user_Info['hashed_password']:
                        auth_token = secrets.token_hex(8) 
                        hashed_token_body = hashlib.sha256((auth_token).encode('utf-8')).hexdigest()
                        hashed_token = bytes(hashed_token_body, 'utf-8')
                        filter = { 'user_name_registed': id_db_user_Info['user_name_registed'] }
                        updated_value = { "$set": { 'token': hashed_token} }
                        id_collection.update_one(filter, updated_value)
                        string_response = 'HTTP/1.1 302 Found\r\nContent-Length: 0\r\nLocation: http://localhost:8080/ \r\nX-Content-Type-Options: nosniff\r\nSet-Cookie: auth_token = {}; Max-Age = 3600; HttpOnly\r\n\r\n'.format(auth_token)
                        response = bytes(string_response, 'utf-8')
                        self.request.sendall(response)
                    else:
                        body = 'Invalid password'
                        message_content = bytes(body, 'utf-8')
                        content_length = len(message_content)
                        string_response = 'HTTP/1.1 302 Found\r\nContent-Length: {}\r\nLocation: http://localhost:8080/ \r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                        response = bytes(string_response, 'utf-8') + message_content
                        self.request.sendall(response)

#Security 14

        elif request.path.split('/')[1] == 'logout':
            if 'auth_token' in request.cookies:
                hashed_token_body = hashlib.sha256((request.cookies['auth_token']).encode('utf-8')).hexdigest()
                hashed_token = bytes(hashed_token_body, 'utf-8')
                cursor = id_collection.find({"token": hashed_token})
                listfyCursor = list(cursor)
                if len(listfyCursor) != 0:
                    try:
                        db_user_Info = listfyCursor[0]
                        filter = { 'user_name_registed': db_user_Info['user_name_registed'] }
                        updated_value = { "$set": { 'token': None} }  
                        id_collection.update_one(filter, updated_value)    
                        string_response = 'HTTP/1.1 302 Found\r\nContent-Length: 0\r\nLocation: http://localhost:8080/ \r\nSet-Cookie: auth_token = None; Expires =Thu, 01 Jan 1800 00:00:00 GMT;\r\nX-Content-Type-Options: nosniff\r\n\r\n'
                        response = bytes(string_response, 'utf-8')
                        self.request.sendall(response) 
                    except:
                        pass
                
                
        elif request.path == '/post-media':
            content_value = b''
            received_data = request.body
            request_with_header = request
            end_bdry = b'\r\n' + b'--' + bytes(parse_multipart(request).boundary,'utf-8') + b'--' + b'\r\n'

            content_value = content_value + received_data
            while content_value.endswith(end_bdry) == False:
                
                #"large TCP buffer"
                # this is a 1024 bytes small buffer
                received_data = self.request.recv(1024)
                content_value = content_value + received_data

            request_with_header.body = content_value
            parsed = parse_multipart(request_with_header)

            for item in parsed.parts:
                range_1_4 = item.content[0:4]
                range_4_8 = item.content[0:4]
                range_8_12 = item.content[8:12]
                range_12_16 = item.content[0:4]
                
                range_1_6 = item.content[0:6]
                range_1_8 = item.content[0:8]
                range_1_12 = item.content[0:12]
                range_6_8 = item.content[6:8]
                range_0_12 = item.content[0:12]
                range_4_12 = item.content[4:12]
                
                fileType = ''
                
                if range_1_4 == b'\xFF\xD8\xFF\xDB':
                    fileType = '.jpg'
                elif range_1_12 == b'\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00\x01':
                    fileType = '.jpg'
                elif range_1_4 == b'\xFF\xD8\xFF\xEE':
                    fileType = '.jpg'
                elif range_1_4 == b'\xFF\xD8\xFF\xE1' and range_6_8 == b'\x45\x78' and  range_8_12 == b'\x69\x66\x00\x00':
                    fileType = '.jpg'
                elif range_1_4 == b'\xFF\xD8\xFF\xE0':
                    fileType = '.jpg'
                    
                elif range_1_8 == b'\x89\x50\x4E\x47\x0D\x0A\x1A\x0A':
                    fileType = '.png'
                    
                elif range_1_6 == b'\x47\x49\x46\x38\x37\x61':
                    fileType = '.gif'
                elif range_1_6 == b'\x47\x49\x46\x38\x39\x61':
                    fileType = '.gif'
                    
                elif range_4_12 == b'\x66\x74\x79\x70\x69\x73\x6F\x6D':
                    fileType = '.mp4'
                elif range_4_12 == b'\x66\x74\x79\x70\x4D\x53\x4E\x56':
                    fileType = '.mp4'
                    
                else:
                    fileType = '.unsupport'
                    
                new_image_name = secrets.token_hex(16)
                new_image_name = new_image_name + fileType
                current_directory = 'public/image/'+new_image_name
                with open(current_directory, 'wb') as image:
                    image.write(item.content)

            id = getLastMessageID() + 1
            message = current_directory
            username = "Guest"
            html_type = ''
            if fileType == '.png' or fileType == '.gif' or fileType == '.jpg':
                html_type = 'image'
            elif fileType == '.mp4':
                html_type = 'video'
            else:
                html_type = 'unsupport'
            if 'auth_token' in request_with_header.cookies:
                hashed_token_body = hashlib.sha256((request_with_header.cookies['auth_token']).encode('utf-8')).hexdigest()
                hashed_token = bytes(hashed_token_body, 'utf-8')
                cursor = id_collection.find({"token": hashed_token})
                listfyCursor = list(cursor)
                
                if len(listfyCursor) != 0:
                    id_db_user_Info = listfyCursor[0]
                    username = id_db_user_Info['user_name_registed']
                    chat_collection.insert_one({"message": message, "username": username, "id": str(id), "messageType": html_type})
                    redirect_response = 'HTTP/1.1 302 Found\r\nLocation: http://localhost:8080/\r\n\r\n'
                    self.request.sendall(bytes(redirect_response, 'utf-8'))
                else:
                    chat_collection.insert_one({"message": message, "username": username, "id": str(id),"messageType": html_type})
                    redirect_response = 'HTTP/1.1 302 Found\r\nLocation: http://localhost:8080/\r\n\r\n'
                    self.request.sendall(bytes(redirect_response, 'utf-8'))
            else:
                chat_collection.insert_one({"message": message, "username": username, "id": str(id),"messageType": html_type})
                redirect_response = 'HTTP/1.1 302 Found\r\nLocation: http://localhost:8080/\r\n\r\n'
                self.request.sendall(bytes(redirect_response, 'utf-8'))
                
                
        elif request.path.split('/')[1] == 'websocket':
            
            username = "Guest" 
            if 'auth_token' in request.cookies:
                hashed_token_body = hashlib.sha256((request.cookies['auth_token']).encode('utf-8')).hexdigest()
                hashed_token = bytes(hashed_token_body, 'utf-8')
                cursor = id_collection.find({"token": hashed_token})
                listfyCursor = list(cursor)
                if len(listfyCursor) != 0:
                    try:
                        db_user_Info = listfyCursor[0]
                        username = db_user_Info['user_name_registed']
                    except:
                        pass
                else:
                    pass
            MyTCPHandler.auth_user[self] = username
            accept = compute_accept(request.headers["Sec-WebSocket-Key"])
            header = "Sec-WebSocket-Accept: " + accept  + "\r\n"
            bytes_header = header.encode()
            response = b'HTTP/1.1 101 Switching Protocols\r\n' +\
                b'Upgrade: websocket\r\nConnection: Upgrade\r\n'+ bytes_header + b'\r\n' + b''
            self.request.sendall(response)
            MyTCPHandler.clients.append(self)
            
            json_user_list = []
            for user in MyTCPHandler.clients:
                if MyTCPHandler.auth_user[user] != 'Guest':
                    json_user_list.append(MyTCPHandler.auth_user[user])
            user_json_response = json.dumps({'messageType': 'user_List', 'users': json_user_list}).encode("utf-8")
            for client in MyTCPHandler.clients:
                client.request.sendall(generate_ws_frame(user_json_response))

            json_message = b''
            json_message_buffer = b''
            received_data_buffer = b''
            while True:
                if received_data_buffer == b'':
                   received_data = self.request.recv(2048)
                else:
                    received_data = b''
                received_data = received_data_buffer + received_data
                received_data_buffer = b'' 
                id = getLastMessageID() + 1
                frame = parse_ws_frame(received_data)
                target_length = frame.payload_length
                sum_length = len(frame.payload)
                
                if target_length < 126:
                    current_received_data = received_data[0:6+target_length]
                    received_data_buffer = received_data[6+target_length:]
                elif target_length >= 126 and target_length < 65536:
                    current_received_data = received_data[0:8+target_length]
                    received_data_buffer = received_data[8+target_length:]
                elif target_length >=65536:
                    current_received_data = received_data[0:12+target_length]
                    received_data_buffer = received_data[12+target_length:]
            
                received_data = current_received_data
                
                frame = parse_ws_frame(received_data)
                
                while len(received_data) < target_length:
                    if target_length - sum_length < 2048:
                        received_data = received_data + self.request.recv(target_length - sum_length)
                        sum_length = sum_length + target_length - sum_length
                    else:
                        received_data = received_data + self.request.recv(2048)
                        sum_length = sum_length + 2048
                if frame.fin_bit == 0:
                    json_message_buffer = json_message_buffer + parse_ws_frame(received_data).payload
                    
                if frame.fin_bit == 1:
                    frame = parse_ws_frame(received_data)
                    json_message = json_message_buffer + frame.payload
                    json_message_buffer = b''
                    
                    try:
                        payload = json.loads(json_message)
                        json_message = b''
                        id = getLastMessageID() + 1
                        chat_collection.insert_one({"message": html.escape(payload["message"]), "username": username, "id": str(id),"messageType": 'chatMessage'})
                        message = {
                            'messageType': 'chatMessage', 
                            'username': username, 
                            'message': html.escape(payload["message"]), 
                            'id': str(id)
                            }
                        chat_response = json.dumps(message).encode("utf-8")
                        for client in MyTCPHandler.clients:
                            client.request.sendall(generate_ws_frame(chat_response))
                    except:
                        pass

                    
                if frame.opcode == 8:
                    MyTCPHandler.clients.remove(self)
                    del MyTCPHandler.auth_user[self]
                    json_user_list = []
                    for user in MyTCPHandler.clients:
                        if MyTCPHandler.auth_user[user] != 'Guest':
                            json_user_list.append(MyTCPHandler.auth_user[user])
                    user_json_response = json.dumps({'messageType': 'user_List', 'users': json_user_list}).encode("utf-8")
                    for client in MyTCPHandler.clients:
                        client.request.sendall(generate_ws_frame(user_json_response))

                    break

        else:
            try:
                with open(request.path[1:], 'r'):
                    fileTypeArray = request.path.split(".")
                    fileType = fileTypeArray[1]
                    if fileType == 'css':
                        with open(request.path[1:], "rb") as b:
                            css_content = b.read()
                            content_length = len(css_content)
                        response = b'HTTP/1.1 200 OK\r\nContent-Type: text/css\r\nContent-Length: {content_length}\r\nX-Content-Type-Options: nosniff\r\n\r\n' + css_content
                        self.request.sendall(response)
                    elif fileType == 'js':
                        with open(request.path[1:], "rb") as b:
                            js_content = b.read()
                            content_length = len(js_content)
                        response = b'HTTP/1.1 200 OK\r\nContent-Type: text/javascript\r\nContent-Length: {content_length}\r\nX-Content-Type-Options: nosniff\r\n\r\n' + js_content
                        self.request.sendall(response)
                    elif fileType == 'ico':
                        with open(request.path[1:], "rb") as b:
                            image_content = b.read()
                            content_length = len(image_content)
                        response = b'HTTP/1.1 200 OK\r\nContent-Type: image/x-icon\r\nContent-Length: {content_length}\r\nX-Content-Type-Options: nosniff\r\n\r\n' + image_content
                        self.request.sendall(response)
                    elif fileType == 'jpg' or fileType == 'jepg':
                        with open(request.path[1:], "rb") as b:
                            image_content = b.read()
                            content_length = len(image_content)
                        response = b'HTTP/1.1 200 OK\r\nContent-Type: image/jpeg\r\nContent-Length: {content_length}\r\nX-Content-Type-Options: nosniff\r\n\r\n' + image_content
                        self.request.sendall(response)
                    elif fileType == 'png':
                        with open(request.path[1:], "rb") as b:
                            image_content = b.read()
                            content_length = len(image_content)
                        response = b'HTTP/1.1 200 OK\r\nContent-Type: image/png\r\nContent-Length: {content_length}\r\nX-Content-Type-Options: nosniff\r\n\r\n' + image_content
                        self.request.sendall(response)
                    elif fileType == 'gif':
                        with open(request.path[1:], "rb") as b:
                            image_content = b.read()
                            content_length = len(image_content)
                        response = b'HTTP/1.1 200 OK\r\nContent-Type: image/gif\r\nContent-Length: {content_length}\r\nX-Content-Type-Options: nosniff\r\n\r\n' + image_content
                        self.request.sendall(response)
                    elif fileType == 'mp4':
                        with open(request.path[1:], "rb") as b:
                            image_content = b.read()
                            content_length = len(image_content)
                        response = b'HTTP/1.1 200 OK\r\nContent-Type: video/mp4\r\nContent-Length: {content_length}\r\nX-Content-Type-Options: nosniff\r\n\r\n' + image_content
                        self.request.sendall(response)
            except:
                body = '404 not found'
                message_content = bytes(body, 'utf-8')
                content_length = len(message_content)
                string_response = 'HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: {}\r\nX-Content-Type-Options: nosniff\r\n\r\n'.format(content_length)
                response = bytes(string_response, 'utf-8') + message_content
                self.request.sendall(response)

def main():
    host = "0.0.0.0"
    port = 8080

    socketserver.ThreadingTCPServer.allow_reuse_address = True

    server = socketserver.ThreadingTCPServer((host, port), MyTCPHandler)

    print("Listening on port " + str(port))

    server.serve_forever()


if __name__ == "__main__":
    main()
