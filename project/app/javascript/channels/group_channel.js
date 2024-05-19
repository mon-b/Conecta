import consumer from "channels/consumer"


// Most of the code here comes from 
// https://medium.com/@valentinowong/using-rails-action-cable-with-a-vanilla-javascript-front-end-1e00ed90067e

const messagesListDiv = document.getElementById('messages-list');

// Renders a specific chat room when a user joins it
function renderChatRoom(chatRoomObject) {
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

    // messagesListDiv.prepend(messageDiv);
    messagesListDiv.append(messageDiv); // correct order of messages. maybe because they are returned in id order ascending?
}

// test fix

// import {renderChatRoom, renderMessage} from "../chat_room_module"

// code from chat_room.js

document.addEventListener('DOMContentLoaded',() => {

  const currentGroupUrl = document.URL.substring(0, document.URL.lastIndexOf('/')).substring(0, document.URL.indexOf('?'));
  fetch(`${currentGroupUrl}/messages_json`)
  .then(response => response.json())
  .then(chatRoomObject => {
      renderChatRoom(chatRoomObject)
  })
})

// end


function getCurrentGroupId()
{
  const currentGroupUrl = document.URL.substring(0, document.URL.lastIndexOf('/')).substring(0, document.URL.indexOf('?'));
  const currentGroupId = currentGroupUrl.split('/').slice(-1)[0];
  return currentGroupId
}

consumer.subscriptions.create({
  id: getCurrentGroupId(),
  channel: 'GroupChannel'
}, {
  connected() {
    console.log('WebSocket connected correctly.');
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log('WebSocket closed.');
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Recieved from socket: ", data);
    renderMessage(data);
  }
});
