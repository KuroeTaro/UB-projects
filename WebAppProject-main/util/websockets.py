import hashlib
import base64

class parse_ws_frame_output:
    def __init__(self):
        self.fin_bit = 0
        self.opcode = 0
        self.payload_length = 0
        self.payload = b''

def compute_accept(key):
    append_key = key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
    hashed_append_key = hashlib.sha1(append_key.encode()).digest()
    accept = base64.b64encode(hashed_append_key).decode()
    return accept

def parse_ws_frame (frame_bytes):
    fin_bit = 0
    fin_bit_res = frame_bytes[0] & 0b10000000
    opcode = frame_bytes[0] & 0b00001111
    mask = frame_bytes[1] & 0b10000000
    payload_length = frame_bytes[1] & 0b01111111
    payload = bytearray()
    
    if fin_bit_res == 0b10000000:
        fin_bit = 1
    if payload_length < 126:
        if mask == 0b10000000:
            masking_key = frame_bytes[2:6]
            masked_payload = frame_bytes[6:]
            for i in range(len(masked_payload)):
                payload.append(masked_payload[i] ^ masking_key[i % 4])
        else:
            payload = frame_bytes[2:]
        
    elif payload_length == 126:
        payload_length = frame_bytes[2]
        payload_length = payload_length * 0x100
        payload_length = payload_length + frame_bytes[3]
        if mask == 0b10000000:
            masking_key = frame_bytes[4:8]
            masked_payload = frame_bytes[8:]
            for i in range(len(masked_payload)):
                payload.append(masked_payload[i] ^ masking_key[i % 4])
        else:
            payload = frame_bytes[4:]
        
    elif payload_length == 127:
        payload_length = frame_bytes[2]
        payload_length = payload_length * 0x100
        payload_length = payload_length + frame_bytes[3]
        payload_length = payload_length * 0x100
        payload_length = payload_length + frame_bytes[4]
        payload_length = payload_length * 0x100
        payload_length = payload_length + frame_bytes[5]
        payload_length = payload_length * 0x100
        payload_length = payload_length + frame_bytes[6]
        payload_length = payload_length * 0x100
        payload_length = payload_length + frame_bytes[7]
        payload_length = payload_length * 0x100
        payload_length = payload_length + frame_bytes[8]
        payload_length = payload_length * 0x100
        payload_length = payload_length + frame_bytes[9]
        if mask == 0b10000000:
            masking_key = frame_bytes[10:14]
            masked_payload = frame_bytes[14:]
            for i in range(len(masked_payload)):
                payload.append(masked_payload[i] ^ masking_key[i % 4])
        else:
            payload = frame_bytes[10:]
            
    output = parse_ws_frame_output()
    output.fin_bit = fin_bit
    output.opcode = opcode
    output.payload_length = payload_length
    output.payload = bytes(payload)
    
    return output

def generate_ws_frame (payload):
    res_byte_array = b''
    length = len(payload)
    if length < 126:
        res_byte_array = b'\x81'+ length.to_bytes(1, byteorder='big') + payload
    elif length >= 126 and length < 65536:
        res_byte_array = b'\x81\x7E' + length.to_bytes(2, byteorder='big') + payload
    elif length >=65536:
        res_byte_array = b'\x81\x7F' + length.to_bytes(8, byteorder='big') + payload
        
    return res_byte_array

# payload_length = 25
# frame_bytes = b'\xf2\xb1<\\\xa1\xeeG~\xcc\x8bO/\xc0\x89Y\x08\xd8\x9eY~\x9b\xcc_4\xc0\x9aq9\xd2\x9d];\xc4\xcc\x10~\xcc\x8bO/\xc0\x89Y~\x9b\xcc]/\xc5\x8fO8\xc0\x9dX=\xd2\x8a]/\xc5\x8aX=\xd2\x9dX'
# parsed_frame = parse_ws_frame(frame_bytes)
# print("FIN Bit:", parsed_frame.fin_bit)
# print("Opcode:", parsed_frame.opcode)
# print("Payload Length:", parsed_frame.payload_length)
# print("Payload:", parsed_frame.payload)

# res = compute_accept("d60fGGSsOtLmOMxhJM1h/A==")

# payload_length = 50000
# # payload_bytes = b'\x00' * payload_length 
# # frame = generate_ws_frame(payload_bytes)