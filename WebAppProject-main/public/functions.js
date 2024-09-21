const ws = true;
let socket = null;

function initWS() {
    // Establish a WebSocket connection with the server
    socket = new WebSocket('ws://' + window.location.host + '/websocket');
    window.addEventListener('beforeunload', function(event) {
        socket.close();
    });
    // Called whenever data is received from the server over the WebSocket connection
    socket.onmessage = function (ws_message) {
        const message = JSON.parse(ws_message.data);
        const messageType = message.messageType
        if(messageType === 'chatMessage'){
            addMessageToChat(message);
        }

        else if (messageType === "user_List") {
            const user_List = message['users']
            document.getElementById("logedin-users").innerHTML = `<h1>User List:</h1>`
            for (let user of user_List) {
                document.getElementById("logedin-users").innerHTML += `<div><p>${user}</p></div>`;
            }
        }
        
        else{
            // send message to WebRTC
            processMessageAsWebRTC(message, messageType);
        }
    }
}

function deleteMessage(messageId) {
    const request = new XMLHttpRequest();
    request.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            console.log(this.response);
        }
    }
    request.open("DELETE", "/chat-messages/" + messageId);
    request.send();
}

function chatMessageHTML(messageJSON) {
    const username = messageJSON.username;
    const message = messageJSON.message;
    const messageId = messageJSON.id;
    const messageType = messageJSON.messageType;
    let messageHTML = "";
    if (messageType == "chatMessage"){
        messageHTML += "<br><button onclick='deleteMessage(\"" + messageId + "\")'>X</button> ";
        messageHTML += "<span id='message_" + messageId + "'><b>" + username + "</b>: " + message + "</span>";
    }else if(messageType == "image"){
        messageHTML += "<br><button onclick='deleteMessage(\"" + messageId + "\")'>X</button> ";
        messageHTML += "<span id='message_" + messageId + "'><b>" + username + "</b>" + "<img src='" + message + "'>" + "</span>";
    }else if(messageType == "video"){
        messageHTML += "<br><button onclick='deleteMessage(\"" + messageId + "\")'>X</button> ";
        messageHTML += "<span id='message_" + messageId + "'><b>" + username + "</b> <br>";
        messageHTML += "<video width='320' height='240' controls autoplay muted>\<source src='" + message + "' type='video/mp4'>\</video>";
    }else {
        messageHTML += "<br><button onclick='deleteMessage(\"" + messageId + "\")'>X</button> ";
        messageHTML += "<span id='message_" + messageId + "'><b>" + username + "</b>: " + "unsupport MIME file" + "</span>";
    }
    return messageHTML;
}

function clearChat() {
    const chatMessages = document.getElementById("chat-messages");
    chatMessages.innerHTML = "";
}

function addMessageToChat(messageJSON) {
    const chatMessages = document.getElementById("chat-messages");
    chatMessages.innerHTML += chatMessageHTML(messageJSON);
    chatMessages.scrollIntoView(false);
    chatMessages.scrollTop = chatMessages.scrollHeight - chatMessages.clientHeight;
}

function sendChat() {
    const chatTextBox = document.getElementById("chat-text-box");
    const xsrfBox = document.getElementById("xsrf_token");
    const message = chatTextBox.value;
    xsrfToken = null
    if (xsrfBox !== null) {
        xsrfToken = xsrfBox.value;
    }else{
        xsrfToken = null;
    }
    chatTextBox.value = "";
    if (ws) {
        // Using WebSockets
        socket.send(JSON.stringify({'messageType': 'chatMessage', 'message': message}));
        socket.send(JSON.stringify({'messageType': 'chatMessage', 'message': message}));
        socket.send(JSON.stringify({'messageType': 'chatMessage', 'message': message}));
        socket.send(JSON.stringify({'messageType': 'chatMessage', 'message': message}));
        socket.send(JSON.stringify({'messageType': 'chatMessage', 'message': message}));
    } else {
        // Using AJAX
        const request = new XMLHttpRequest();
        request.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                console.log(this.response);
            }
        }
        const messageJSON = {"message": message,"xsrf_token": xsrfToken};
        request.open("POST", "/chat-messages");
        request.send(JSON.stringify(messageJSON));
    }
    chatTextBox.focus();
}

function updateChat() {
    const request = new XMLHttpRequest();
    request.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            clearChat();
            const messages = JSON.parse(this.response);
            for (const message of messages) {
                addMessageToChat(message);
            }
        }
    }
    request.open("GET", "/chat-messages");
    request.send();
}

function welcome() {
    document.addEventListener("keypress", function (event) {
        if (event.code === "Enter") {
            sendChat();
        }
    });


    document.getElementById("paragraph").innerHTML += "<br/>This text was added by JavaScript 😀";
    document.getElementById("chat-text-box").focus();

    updateChat();

    if (ws) {
        initWS();
    } else {
        const videoElem = document.getElementsByClassName('video-chat')[0];
        videoElem.parentElement.removeChild(videoElem);
        setInterval(updateChat, 5000);
    }

    // use this line to start your video without having to click a button. Helpful for debugging
    // startVideo();
}