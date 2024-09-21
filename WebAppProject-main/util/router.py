import re
class Router:

    def __init__(self):
        self.routes = {}

    def add_route(self, HTTP_method, path_pattern, byte_return_function):
        if HTTP_method in self.routes:
            if path_pattern in self.routes[HTTP_method]:
                pass
            else:
                self.routes[HTTP_method][path_pattern] = byte_return_function
        else:
            self.routes[HTTP_method] = {}
            self.routes[HTTP_method][path_pattern] = byte_return_function
            
    def route_request(self, request_object):
        method = request_object.method
        path = request_object.path
        if method in self.routes:
            for key in self.routes[method]:
                if re.match(key, path):
                    res = self.routes[method][key](request_object)
                    return res
        res = b'HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: 13\r\nX-Content-Type-Options: nosniff\r\n\r\n404 not found'
        return res

# def test1():
#     def return_html(request_object):
#         print("return_html")
#     exp_router = Router()
#     exp_router.add_route('GET','^/$',return_html)
#     ep1 =  Request(b'GET / HTTP/1.1\r\nHost: www.example.com\r\nUser-Agent: Mozilla/5.0\r\nAccept: text/html,application/xhtml+xml\r\nAccept-Language: en-US,en;q=0.5\r\nAccept-Encoding: gzip, deflate\r\nConnection: keep-alive\r\nCookie: session_id=ABC123; user_pref=dark_mode\r\n\r\n')
#     res = exp_router.route_request(ep1)
#     pass

# if __name__ == '__main__':
#     test1()
