# from request import Request

def extract_credentials(input_request):
    content = str(input_request.body, encoding='utf-8')
    mid_content = content.split("&")
    mid_content_1 = str(mid_content[0].split("=")[1])
    length = len(mid_content[0])
    mid_content_2 = str(content[length+1:])
    mid_content_3 = str(mid_content_2.split("=")[0])
    length = len(mid_content_3)
    mid_content_4 = str(mid_content_2[length+1:])
    mid_content_4 = mid_content_4.replace("%21", "!")
    mid_content_4 = mid_content_4.replace("%40", "@")
    mid_content_4 = mid_content_4.replace("%23", "#")
    mid_content_4 = mid_content_4.replace("%24", "$")
    mid_content_4 = mid_content_4.replace("%5E", "^")
    mid_content_4 = mid_content_4.replace("%26", "&")
    mid_content_4 = mid_content_4.replace("%28", "(")
    mid_content_4 = mid_content_4.replace("%29", ")")
    mid_content_4 = mid_content_4.replace("%2D", "-")
    mid_content_4 = mid_content_4.replace("%5F", "_")
    mid_content_4 = mid_content_4.replace("%20", " ")
    mid_content_4 = mid_content_4.replace("%3D", "=")
    mid_content_4 = mid_content_4.replace("%25", "%")
    return [mid_content_1, mid_content_4]

def validate_password(password):
    if len(password) < 8:
        return False
    lowercaseFlag = False
    uppercaseFlag = False
    numberFlag = False
    specialFlag = False

    lowercasePool = "abcdefghijklmnopqrstuvwxyz"
    uppercasePool = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    numberPool = "0123456789"
    specialPool = "!@#$%^&()-_="
    allPool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&()-_="

    for char in password:
        if not lowercaseFlag and char in lowercasePool:
            lowercaseFlag = True
        if not uppercaseFlag and char in uppercasePool:
            uppercaseFlag = True
        if not numberFlag and char in numberPool:
            numberFlag = True
        if not specialFlag and char in specialPool:
            specialFlag = True

        if char not in allPool:
            return False

    return lowercaseFlag and uppercaseFlag and numberFlag and specialFlag

# def test1():
#     def return_html(request_object):
#         print("return_html")
#     ep1 =  Request(b'POST /register HTTP/1.1\r\nHost: localhost:8080\r\nConnection: keep-alive\r\nContent-Length: 38\r\nCache-Control: max-age=0\r\nsec-ch-ua: "Chromium";v="122", "Not(A:Brand";v="24", "Google Chrome";v="122"\r\nsec-ch-ua-mobile: ?0\r\nsec-ch-ua-platform: "Windows"\r\nOrigin: http://localhost:8080\r\nDNT: 1\r\nUpgrade-Insecure-Requests: 1\r\nContent-Type: application/x-www-form-urlencoded\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nSec-Fetch-Site: same-origin\r\nSec-Fetch-Mode: navigate\r\nSec-Fetch-User: ?1\r\nSec-Fetch-Dest: document\r\nReferer: http://localhost:8080/\r\nAccept-Encoding: gzip, deflate, br, zstd\r\nAccept-Language: zh-CN,zh;q=0.9,en;q=0.8\r\nCookie: Max-Age=3600; visits=5\r\n\r\nusername_reg=sasddsdsaa&password_reg=asdd%24%5EqwesdDWW')
#     listA = extract_credentials(ep1)
#     pass
# # def test2():
# #     res = validate_password("1sD!")
# #     pass
# #     res = validate_password("asdjhsdjh123^")
# #     pass
# #     res = validate_password("ASJHDV123(")
# #     pass
# #     res = validate_password("asdddASD$")
# #     pass
# #     res = validate_password("sjhduyeASDD223")
# #     pass
# #     res = validate_password("++asdhjkhbc123@DSS")
# #     pass
# if __name__ == '__main__':
#     test1()
