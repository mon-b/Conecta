// Most of the code here comes from 
// https://medium.com/@valentinowong/using-rails-action-cable-with-a-vanilla-javascript-front-end-1e00ed90067e

const apiUrl = 'http://localhost:3000'
const webSocketUrl = 'ws://localhost:3000/cable'
const chatRoomListDiv = document.getElementById('chat-rooms-list');
const messagesListDiv = document.getElementById('messages-list');


// // Renders an individual chat room onto the chat room list
// function renderChatRoomOnList(chatRoomObject) {
//     const chatRoomDiv = document.createElement('div');

//     chatRoomDiv.innerHTML = `${chatRoomObject.name} <button class='join-chat-room-button' data-chat-room-id='${chatRoomObject.id}'>Join</button>`

//     chatRoomListDiv.prepend(chatRoomDiv);
// }

// Renders a specific chat room when a user joins it
function renderChatRoom(chatRoomObject) {
    const chatRoomDiv = document.getElementById('chat-room-div');

    const chatRoomNameH3 = document.createElement('h3');
    console.log(chatRoomObject)
    chatRoomNameH3.textContent = chatRoomObject.name;

    chatRoomDiv.prepend(chatRoomNameH3);

    // Show the new message form // NOT NEEDED

    chatRoomObject.forEach( messageObject => {
        renderMessage(messageObject)
    })
}

// Renders a specific message
function renderMessage(messageObject) {
    const messageDiv = document.createElement('div')

    messageDiv.innerHTML = ``
    messageDiv.textContent = messageObject.username_raw +  ": " + messageObject.content;
    messageDiv.dataset.messageId = messageObject.id;

    messagesListDiv.prepend(messageDiv);
}

// Opens a websocket connection to a specific Chat Room stream
function createChatRoomWebsocketConnection(chatRoomId) {
    
    // Creates the new websocket connection
    socket = new WebSocket(webSocketUrl);

        // When the connection is 1st created, this code runs subscribing the clien to a specific chatroom stream in the ChatRoomChannel
        socket.onopen = function(event) {
            console.log('WebSocket is connected.');

            const msg = {
                command: 'subscribe',
                identifier: JSON.stringify({
                    id: chatRoomId,
                    channel: 'GroupChannel'
                }),
            };
    
            socket.send(JSON.stringify(msg));
        };
        
        // When the connection is closed, this code is run
        socket.onclose = function(event) {
        console.log('WebSocket is closed.');
        };

        // When a message is received through the websocket, this code is run
        socket.onmessage = function(event) {            
            const response = event.data;
            const msg = JSON.parse(response);
            
            // Ignores pings
            if (msg.type === "ping") {
                return;
            } 

            console.log("FROM RAILS: ", msg);
            
            // Renders any newly created messages onto the page
            if (msg.message) {
                renderMessage(msg.message)
            }
            
          };
        
        // When an error occurs through the websocket connection, this code is run printing the error message
        socket.onerror = function(error) {
            console.log('WebSocket Error: ' + error);
        };
}

document.addEventListener('DOMContentLoaded',() => {

    // professional solution from https://www.freecodecamp.org/news/how-to-get-the-current-url-with-javascript/

    // Fetch and render the group chat room
    // let currentUrl = window.content.href;
    // let currentUrl = document.URL;
    // console.log(currentUrl);
    // momento javascript
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/lastIndexOf
    // https://stackoverflow.com/questions/5631384/remove-everything-after-a-certain-character
    // currentUrl = currentUrl.substring(0, currentUrl.lastIndexOf('/'));
    // console.log(currentUrl);
    // console.log(currentUrl.substring(0, currentUrl.lastIndexOf('/')));

    const currentGroupUrl = document.URL.substring(0, document.URL.lastIndexOf('/'));
    console.log(currentGroupUrl);
    // const tmpUrlSplit = currentGroupUrl.split('/')[-1];
    // const currentGroupId = currentGroupUrl.split('/')[tmpUrlSplit.length];
    // https://stackoverflow.com/a/53731605/5674961
    const currentGroupId = currentGroupUrl.split('/').slice(-1)[0];
    console.log(currentGroupId);
    // fetch(`${apiUrl}/groups/${event.target.dataset.chatRoomId}/messages_json`)
    // ver q el fetch ocupe los parametros actuales
    fetch(`${currentGroupUrl}/messages_json`)
    .then(response => response.json())
    .then(chatRoomObject => {
        renderChatRoom(chatRoomObject)
    })
    // Open up a websocket connection for that specific chat room
    createChatRoomWebsocketConnection(currentGroupId)

    // // Fetch and render the group chat room
    // fetch(`${apiUrl}/groups/${event.target.dataset.chatRoomId}/messages_json`)
    // .then(response => response.json())
    // .then(chatRoomObject => {
    //     renderChatRoom(chatRoomObject)
    // })
    // // Open up a websocket connection for that specific chat room
    // createChatRoomWebsocketConnection(event.target.dataset.chatRoomId)


    // // Allow users to join new chat rooms
    // chatRoomListDiv.addEventListener('click', event => {
    //     if (event.target.className === 'join-chat-room-button') {
            
    //         // Hide the chat room list
    //         const chatRoomsDiv = document.getElementById('chat-rooms-div')
    //         chatRoomsDiv.style.display = 'none'

    //         // Fetch & render info on a specific chat room from the server 
    //         fetch(`${apiUrl}/chat_rooms/${event.target.dataset.chatRoomId}`)
    //             .then(response => response.json())
    //             .then(chatRoomObject => {
    //                 renderChatRoom(chatRoomObject)
    //             })

    //         // Open up a websocket connection for that specific chat room
    //         createChatRoomWebsocketConnection(event.target.dataset.chatRoomId)
    //     }
    // })

})